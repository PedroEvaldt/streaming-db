package main

import (
	"database/sql"
	"log/slog"

	"github.com/PedroEvaldt/streaming-db/config"
)

func AbrirConexao(dsn string, logger *slog.Logger) (*sql.DB, error) {
	db, err := sql.Open(config.Driver, dsn)
	if err != nil {
		logger.Error("could not connect to db", "error", err.Error())
		return nil, err
	}

	if err = db.Ping(); err != nil {
		logger.Error("could not ping to db", "error", err.Error())
		CloseDB(db, logger)
		return nil, err
	}
	return db, nil
}

func CloseDB(db *sql.DB, logger *slog.Logger) {
	err := db.Close()
	if err != nil {
		logger.Error("could not close db connection", "error", err.Error())
	}
}
