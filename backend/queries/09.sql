SELECT
    g.nome AS genero,
    COUNT(*) AS qtd_avaliacoes,
    AVG(v.nota) AS nota_media
FROM vw_avaliacao_perfil_titulo v
JOIN titulo_genero tg ON tg.id_titulo = v.id_titulo
JOIN genero g ON g.id_genero = tg.id_genero
WHERE v.tipo_conteudo = 'adulto'
GROUP BY g.nome;
