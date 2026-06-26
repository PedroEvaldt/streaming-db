SELECT
  t.nome AS titulo,
  COUNT(a.id_avaliacao) AS qtd_avaliacoes,
  AVG(a.nota) AS nota_media
FROM
  titulo t
  JOIN avaliacao a ON a.id_titulo = t.id_titulo
  JOIN perfil p ON p.id_perfil = a.id_perfil
WHERE
  p.tipo_conteudo = 'adulto'
GROUP BY
  t.nome
HAVING
  COUNT(a.id_avaliacao) > $1;
