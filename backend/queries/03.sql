SELECT
    g.nome AS genero,
    COUNT(tg.id_titulo) AS qtd_titulos
FROM genero g
JOIN titulo_genero tg ON tg.id_genero = g.id_genero
JOIN titulo t ON t.id_titulo = tg.id_titulo
GROUP BY g.nome;
