SELECT
    t.id_titulo,
    t.nome
FROM titulo t
WHERE NOT EXISTS (
    SELECT 1
    FROM lista_item li
    JOIN lista l ON l.id_lista = li.id_lista
    WHERE li.id_titulo = t.id_titulo
      AND l.nome = 'Minha Lista'
);
