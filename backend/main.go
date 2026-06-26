package main

import (
	"fmt"
	"log/slog"
	"os"

	"github.com/PedroEvaldt/streaming-db/config"
	_ "github.com/jackc/pgx/v5/stdlib"
)

var DataSourceName = fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=disable", config.User, config.Password, config.Host, config.Port, config.DBName)

func main() {
	logger := slog.New(slog.NewTextHandler(os.Stdout, nil))
	db, err := AbrirConexao(DataSourceName, logger)
	if err != nil {
		os.Exit(1)
	}
	defer CloseDB(db, logger)

	logger.Info("Connected")
	linhas1, err := PerfilsPorPlano(db)
	if err != nil {
		logger.Error("consulta 1 falhou", "error", err)
		os.Exit(1)
	}
	fmt.Println("--- C1 ---")
	for _, l := range linhas1 {
		fmt.Println(l)
	}
	linhas3, err := TitulosPorGenero(db)
	if err != nil {
		logger.Error("consulta 3 falhou", "error", err)
		os.Exit(1)
	}
	fmt.Println("--- C3 ---")
	for _, l := range linhas3 {
		fmt.Println(l)
	}
	linhas5, err := SeriesComEpLongo(db)
	if err != nil {
		logger.Error("consulta 5 falhou", "error", err)
		os.Exit(1)
	}
	fmt.Println("--- C5 ---")
	for _, l := range linhas5 {
		fmt.Println(l)
	}
	linhas7, err := TitulosForaDasListas(db)
	if err != nil {
		logger.Error("consulta 7 falhou", "error", err)
		os.Exit(1)
	}
	fmt.Println("--- C7 ---")
	for _, l := range linhas7 {
		fmt.Println(l)
	}
	linhas10, err := EquipeTitulosInfantis(db)
	if err != nil {
		logger.Error("consulta 10 falhou", "error", err)
		os.Exit(1)
	}
	fmt.Println("--- C10 ---")
	for _, l := range linhas10 {
		fmt.Println(l)
	}
}
