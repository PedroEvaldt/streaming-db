-- =====================================================================
-- Plataforma de Streaming - Visão e Consultas SQL
-- consultas.sql
-- Compatível com PostgreSQL e MySQL (SQL padrão)
-- =====================================================================
-- =====================================================================
-- ITEM 2.a) VISÃO
-- =====================================================================
-- Enunciado: visão que combina avaliacao, perfil e titulo, expondo de
-- forma simplificada quem avaliou (perfil), o que foi avaliado (titulo)
-- e a nota/comentário atribuídos. É utilizada nas Consultas 8 e 9.
CREATE VIEW vw_avaliacao_perfil_titulo AS
SELECT
  a.id_avaliacao,
  a.id_perfil,
  p.nome AS nome_perfil,
  p.tipo_conteudo,
  a.id_titulo,
  t.nome AS nome_titulo,
  t.tipo AS tipo_titulo,
  t.ano_lancamento,
  a.nota,
  a.comentario,
  a.data_avaliacao
FROM
  avaliacao a
  JOIN perfil p ON p.id_perfil = a.id_perfil
  JOIN titulo t ON t.id_titulo = a.id_titulo;
