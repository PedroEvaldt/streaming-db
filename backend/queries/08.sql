SELECT
    v.nome_perfil,
    v.nome_titulo,
    v.nota,
    g.nome AS genero
FROM vw_avaliacao_perfil_titulo v
JOIN titulo_genero tg ON tg.id_titulo = v.id_titulo
JOIN genero g ON g.id_genero = tg.id_genero
WHERE v.tipo_conteudo = 'adulto'
  AND v.tipo_titulo = 'filme'
  AND v.nota = 5;
