SELECT
    pl.nome AS plano,
    COUNT(pf.id_perfil) AS qtd_perfis
FROM plano pl
JOIN usuario u ON u.id_plano = pl.id_plano
JOIN perfil pf ON pf.id_usuario = u.id_usuario
GROUP BY pl.nome;
