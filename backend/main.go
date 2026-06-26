package main

import (
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"

	"github.com/PedroEvaldt/streaming-db/config"
	_ "github.com/jackc/pgx/v5/stdlib"
)

func main() {
	logger := slog.New(slog.NewTextHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	dsn := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=disable", config.User, config.Password, config.Host, config.Port, config.DBName)
	db, err := AbrirConexao(dsn, logger)
	if err != nil {
		os.Exit(1)
	}
	defer CloseDB(db, logger)

	logger.Info("Connected to db")

	mux := http.NewServeMux()
	mux.HandleFunc("GET /consultas/1", handlerConsulta1(db))
	mux.HandleFunc("GET /consultas/2", handlerConsulta2(db))
	mux.HandleFunc("GET /consultas/3", handlerConsulta3(db))
	mux.HandleFunc("GET /consultas/4", handlerConsulta4(db))
	mux.HandleFunc("GET /consultas/5", handlerConsulta5(db))
	mux.HandleFunc("GET /consultas/6", handlerConsulta6(db))
	mux.HandleFunc("GET /consultas/7", handlerConsulta7(db))
	mux.HandleFunc("GET /consultas/8", handlerConsulta8(db))
	mux.HandleFunc("GET /consultas/9", handlerConsulta9(db))
	mux.HandleFunc("GET /consultas/10", handlerConsulta10(db))

	server := &http.Server{
		Addr:    ":8080",
		Handler: loggingMiddleware(corsMiddleware(mux)),
	}
	err = server.ListenAndServe()
	if errors.Is(err, http.ErrServerClosed) {
		logger.Info("server closed")
	} else if err != nil {
		logger.Error("error listening for server", "error", err)
	}
}
