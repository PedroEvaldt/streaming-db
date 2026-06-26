package main

import (
	"log/slog"
	"net/http"
	"time"
)

type respLog struct {
	http.ResponseWriter
	status int
}

func (rl *respLog) WriteHeader(code int) {
	rl.status = code
	rl.ResponseWriter.WriteHeader(code)
}

func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET,OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type,Authorization")
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		now := time.Now()
		rl := &respLog{ResponseWriter: w, status: http.StatusOK}
		next.ServeHTTP(rl, r)
		slog.Default().Info("request", "method", r.Method, "path", r.URL.Path, "status", rl.status, "time", time.Since(now))
	})
}
