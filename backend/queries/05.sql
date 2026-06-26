SELECT DISTINCT
    t.nome AS titulo,
    g.nome AS genero
FROM titulo t
JOIN episodio e ON e.id_titulo = t.id_titulo
JOIN titulo_genero tg ON tg.id_titulo = t.id_titulo
JOIN genero g ON g.id_genero = tg.id_genero
WHERE e.duracao_min > (SELECT AVG(duracao_min) FROM episodio);
