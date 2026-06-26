SELECT
  p.id_perfil,
  p.nome
FROM
  perfil p
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      episodio e
    WHERE
      e.id_titulo = $1
      AND NOT EXISTS (
        SELECT
          1
        FROM
          historico_visualizacao hv
        WHERE
          hv.id_perfil = p.id_perfil
          AND hv.id_episodio = e.id_episodio
      )
  );
