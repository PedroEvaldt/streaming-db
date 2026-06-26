package main

import (
	"database/sql"

	_ "embed"
)

//go:embed queries/01.sql
var perfisPorPlano string

type LinhaConsulta1 struct {
	Plano     string `json:"plano"`
	QntPerfis int    `json:"qnt_perfis"`
}

func PerfisPorPlano(db *sql.DB) ([]LinhaConsulta1, error) {
	return executarScan(db, perfisPorPlano, func(rows *sql.Rows) (LinhaConsulta1, error) {
		var l LinhaConsulta1
		if err := rows.Scan(&l.Plano, &l.QntPerfis); err != nil {
			return LinhaConsulta1{}, err
		}
		return l, nil
	})
}

//go:embed queries/02.sql
var titulosMaisAvaliadosAdulto string

type LinhaConsulta2 struct {
	Titulo        string  `json:"titulo"`
	QtdAvaliacoes int     `json:"qtd_avaliacoes"`
	NotaMedia     float64 `json:"nota_media"`
}

func TitulosMaisAvaliadosAdulto(db *sql.DB, minAvaliacoes int) ([]LinhaConsulta2, error) {
	stmt, err := db.Prepare(titulosMaisAvaliadosAdulto)
	if err != nil {
		return nil, err
	}

	defer func() { _ = stmt.Close() }()

	rows, err := stmt.Query(minAvaliacoes)
	if err != nil {
		return nil, err
	}

	defer func() { _ = rows.Close() }()

	var linhas []LinhaConsulta2
	for rows.Next() {
		var l LinhaConsulta2
		if err := rows.Scan(&l.Titulo, &l.QtdAvaliacoes, &l.NotaMedia); err != nil {
			return nil, err
		}
		linhas = append(linhas, l)
	}
	return linhas, rows.Err()
}

//go:embed queries/03.sql
var titulosPorGenero string

type LinhaConsulta3 struct {
	Genero     string `json:"genero"`
	QntTitulos int    `json:"qnt_titulos"`
}

func TitulosPorGenero(db *sql.DB) ([]LinhaConsulta3, error) {
	return executarScan(db, titulosPorGenero, func(rows *sql.Rows) (LinhaConsulta3, error) {
		var l LinhaConsulta3
		if err := rows.Scan(&l.Genero, &l.QntTitulos); err != nil {
			return LinhaConsulta3{}, err
		}
		return l, nil
	})
}

//go:embed queries/04.sql
var pessoasEmTitulosBemAvaliados string

type LinhaConsulta4 struct {
	Pessoa string `json:"pessoa"`
}

func PessoasEmTitulosBemAvaliados(db *sql.DB) ([]LinhaConsulta4, error) {
	return executarScan(db, pessoasEmTitulosBemAvaliados, func(rows *sql.Rows) (LinhaConsulta4, error) {
		var l LinhaConsulta4
		if err := rows.Scan(&l.Pessoa); err != nil {
			return LinhaConsulta4{}, err
		}
		return l, nil
	})
}

//go:embed queries/05.sql
var seriesComEpLongo string

type LinhaConsulta5 struct {
	Titulo string `json:"titulo"`
	Genero string `json:"genero"`
}

func SeriesComEpLongo(db *sql.DB) ([]LinhaConsulta5, error) {
	return executarScan(db, seriesComEpLongo, func(rows *sql.Rows) (LinhaConsulta5, error) {
		var l LinhaConsulta5
		if err := rows.Scan(&l.Titulo, &l.Genero); err != nil {
			return LinhaConsulta5{}, err
		}
		return l, nil
	})
}

//go:embed queries/06.sql
var perfisAssistiramTodosEp string

type LinhaConsulta6 struct {
	IDPerfil int    `json:"id_perfil"`
	Nome     string `json:"nome"`
}

func PerfisAssistiramTodosEp(db *sql.DB, idTitulo int) ([]LinhaConsulta6, error) {
	stmt, err := db.Prepare(perfisAssistiramTodosEp)
	if err != nil {
		return nil, err
	}

	defer func() { _ = stmt.Close() }()

	rows, err := stmt.Query(idTitulo)
	if err != nil {
		return nil, err
	}

	defer func() { _ = rows.Close() }()

	var linhas []LinhaConsulta6
	for rows.Next() {
		var l LinhaConsulta6
		if err := rows.Scan(&l.IDPerfil, &l.Nome); err != nil {
			return nil, err
		}
		linhas = append(linhas, l)
	}
	return linhas, rows.Err()
}

//go:embed queries/07.sql
var titulosForaDasListas string

type LinhaConsulta7 struct {
	IDTitulo int    `json:"id_titulo"`
	Nome     string `json:"nome"`
}

func TitulosForaDasListas(db *sql.DB) ([]LinhaConsulta7, error) {
	return executarScan(db, titulosForaDasListas, func(rows *sql.Rows) (LinhaConsulta7, error) {
		var l LinhaConsulta7
		if err := rows.Scan(&l.IDTitulo, &l.Nome); err != nil {
			return LinhaConsulta7{}, err
		}
		return l, nil
	})
}

//go:embed queries/08.sql
var avaliacoesNota5FilmesAdulto string

type LinhaConsulta8 struct {
	NomePerfil string `json:"nome_perfil"`
	NomeTitulo string `json:"nome_titulo"`
	Nota       int    `json:"nota"`
	Genero     string `json:"genero"`
}

func AvaliacoesNota5FilmesAdulto(db *sql.DB) ([]LinhaConsulta8, error) {
	return executarScan(db, avaliacoesNota5FilmesAdulto, func(rows *sql.Rows) (LinhaConsulta8, error) {
		var l LinhaConsulta8
		if err := rows.Scan(&l.NomePerfil, &l.NomeTitulo, &l.Nota, &l.Genero); err != nil {
			return LinhaConsulta8{}, err
		}
		return l, nil
	})
}

//go:embed queries/09.sql
var mediaAvaliacoesPorGeneroAdulto string

type LinhaConsulta9 struct {
	Genero        string  `json:"genero"`
	QtdAvaliacoes int     `json:"qtd_avaliacoes"`
	NotaMedia     float64 `json:"nota_media"`
}

func MediaAvaliacoesPorGeneroAdulto(db *sql.DB) ([]LinhaConsulta9, error) {
	return executarScan(db, mediaAvaliacoesPorGeneroAdulto, func(rows *sql.Rows) (LinhaConsulta9, error) {
		var l LinhaConsulta9
		if err := rows.Scan(&l.Genero, &l.QtdAvaliacoes, &l.NotaMedia); err != nil {
			return LinhaConsulta9{}, err
		}
		return l, nil
	})
}

//go:embed queries/10.sql
var equipeTitulosInfantis string

type LinhaConsulta10 struct {
	Perfil string `json:"perfil"`
	Titulo string `json:"titulo"`
	Pessoa string `json:"pessoa"`
	Papel  string `json:"papel"`
}

func EquipeTitulosInfantis(db *sql.DB) ([]LinhaConsulta10, error) {
	return executarScan(db, equipeTitulosInfantis, func(rows *sql.Rows) (LinhaConsulta10, error) {
		var l LinhaConsulta10
		if err := rows.Scan(&l.Perfil, &l.Titulo, &l.Pessoa, &l.Papel); err != nil {
			return LinhaConsulta10{}, err
		}
		return l, nil
	})
}

// Helpers

func executarScan[T any](db *sql.DB, query string, scanner func(*sql.Rows) (T, error)) ([]T, error) {
	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}

	defer func() { _ = rows.Close() }()

	var linhas []T
	for rows.Next() {
		item, err := scanner(rows)
		if err != nil {
			return nil, err
		}
		linhas = append(linhas, item)
	}
	return linhas, rows.Err()
}
