SELECT
    pf.nome AS perfil,
    t.nome  AS titulo,
    pe.nome AS pessoa,
    pa.papel
FROM perfil pf
JOIN historico_visualizacao hv ON hv.id_perfil = pf.id_perfil
JOIN titulo t ON t.id_titulo = hv.id_titulo
JOIN participacao pa ON pa.id_titulo = t.id_titulo
JOIN pessoa pe ON pe.id_pessoa = pa.id_pessoa
WHERE pf.tipo_conteudo = 'infantil';
