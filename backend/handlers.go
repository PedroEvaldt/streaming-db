package main

import (
	"database/sql"
	"encoding/json"
	"log/slog"
	"net/http"
	"strconv"
)

func handlerConsulta1(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		linhas, err := PerfisPorPlano(db)
		responderJSON(w, linhas, err, "erro consulta 1")
	}
}

func handlerConsulta2(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		minAvaliacoes := r.URL.Query().Get("min_avaliacoes")
		minAvaliacoesInt, err := strconv.Atoi(minAvaliacoes)
		if err != nil {
			http.Error(w, "min_avaliacoes invalida", http.StatusBadRequest)
			return
		}
		linhas, err := TitulosMaisAvaliadosAdulto(db, minAvaliacoesInt)
		responderJSON(w, linhas, err, "erro consulta 2")
	}
}

func handlerConsulta3(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		linhas, err := TitulosPorGenero(db)
		responderJSON(w, linhas, err, "erro consulta 3")
	}
}

func handlerConsulta4(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		linhas, err := PessoasEmTitulosBemAvaliados(db)
		responderJSON(w, linhas, err, "erro consulta 4")
	}
}

func handlerConsulta5(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		linhas, err := SeriesComEpLongo(db)
		responderJSON(w, linhas, err, "erro consulta 5")
	}
}

func handlerConsulta6(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		idTitulo := r.URL.Query().Get("id_titulo")
		idTituloInt, err := strconv.Atoi(idTitulo)
		if err != nil {
			http.Error(w, "id_titulo invalido", http.StatusBadRequest)
			return
		}
		linhas, err := PerfisAssistiramTodosEp(db, idTituloInt)
		responderJSON(w, linhas, err, "erro consulta 6")
	}
}

func handlerConsulta7(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		linhas, err := TitulosForaDasListas(db)
		responderJSON(w, linhas, err, "erro consulta 7")
	}
}

func handlerConsulta8(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		linhas, err := AvaliacoesNota5FilmesAdulto(db)
		responderJSON(w, linhas, err, "erro consulta 8")
	}
}

func handlerConsulta9(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		linhas, err := MediaAvaliacoesPorGeneroAdulto(db)
		responderJSON(w, linhas, err, "erro consulta 9")
	}
}

func handlerConsulta10(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		linhas, err := EquipeTitulosInfantis(db)
		responderJSON(w, linhas, err, "erro consulta 10")
	}
}

func responderJSON[T any](w http.ResponseWriter, dados []T, err error, msg string) {
	if err != nil {
		slog.Default().Error(msg, "error", err)
		http.Error(w, msg, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(dados); err != nil {
		slog.Default().Error("falha ao codificar JSON", "consulta", msg, "error", err)
	}
}
