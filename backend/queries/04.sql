SELECT DISTINCT
    pe.nome AS pessoa
FROM pessoa pe
JOIN participacao pa ON pa.id_pessoa = pe.id_pessoa
JOIN titulo t ON t.id_titulo = pa.id_titulo
WHERE t.id_titulo IN (
    SELECT a.id_titulo
    FROM avaliacao a
    GROUP BY a.id_titulo
    HAVING AVG(a.nota) > (SELECT AVG(nota) FROM avaliacao)
);
