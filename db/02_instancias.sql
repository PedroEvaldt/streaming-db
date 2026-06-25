-- =====================================================================
-- Plataforma de Streaming - Instâncias (dados de exemplo)
-- instancias.sql
-- =====================================================================

-- PLANO
INSERT INTO plano (id_plano, nome, preco, qtd_telas_simultaneas, resolucao_max) VALUES
(1, 'Básico',  20.90, 1, 'SD'),
(2, 'Padrão',  32.90, 2, 'HD'),
(3, 'Premium', 44.90, 4, '4K');

-- USUARIO
INSERT INTO usuario (id_usuario, nome, email, senha_hash, data_cadastro, id_plano) VALUES
(1, 'Ana Silva',   'ana.silva@email.com',   'hash1', '2023-01-10', 3),
(2, 'Bruno Costa',  'bruno.costa@email.com', 'hash2', '2023-03-22', 2),
(3, 'Carla Souza',  'carla.souza@email.com', 'hash3', '2023-05-15', 1),
(4, 'Diego Lima',   'diego.lima@email.com',  'hash4', '2024-02-01', 3),
(5, 'Elisa Rocha',  'elisa.rocha@email.com', 'hash5', '2024-06-30', 2);

-- PERFIL
INSERT INTO perfil (id_perfil, id_usuario, nome, tipo_conteudo, data_criacao) VALUES
(1, 1, 'Ana',    'adulto',   '2023-01-10'),
(2, 1, 'Kids',   'infantil', '2023-01-12'),
(3, 2, 'Bruno',  'adulto',   '2023-03-22'),
(4, 2, 'Mãe',    'adulto',   '2023-03-25'),
(5, 3, 'Carla',  'adulto',   '2023-05-15'),
(6, 4, 'Diego',  'adulto',   '2024-02-01'),
(7, 4, 'Filho',  'infantil', '2024-02-03'),
(8, 5, 'Elisa',  'adulto',   '2024-06-30');

-- GENERO
INSERT INTO genero (id_genero, nome) VALUES
(1, 'Drama'),
(2, 'Comédia'),
(3, 'Ação'),
(4, 'Ficção Científica'),
(5, 'Animação'),
(6, 'Documentário');

-- TITULO
INSERT INTO titulo (id_titulo, nome, tipo, ano_lancamento, sinopse, classificacao_indicativa) VALUES
(1, 'Fronteiras do Tempo',   'filme', 2022, 'Um físico tenta corrigir um erro que alterou a linha do tempo.', '14'),
(2, 'Risadas da Madrugada',  'serie', 2021, 'Comediantes enfrentam o dia a dia em uma rádio noturna.',        'L'),
(3, 'Operação Trovão',       'filme', 2023, 'Agente especial impede um ataque em alto-mar.',                  '16'),
(4, 'Mundo Encantado',       'serie', 2020, 'Animação infantil sobre uma floresta mágica.',                   'L'),
(5, 'Sob o Mesmo Céu',       'filme', 2019, 'Drama familiar sobre reencontro após décadas.',                  '12'),
(6, 'Mistérios da Cidade',   'serie', 2022, 'Investigadora desvenda fenômenos inexplicáveis na metrópole.',   '14'),
(7, 'Terra Selvagem',        'filme', 2021, 'Documentário sobre a fauna do Pantanal.',                        'L'),
(8, 'Riso Fácil',            'filme', 2018, 'Comédia romântica sobre dois rivais de trabalho.',               '10');

-- EPISODIO (apenas para títulos do tipo 'serie': 2, 4, 6)
INSERT INTO episodio (id_episodio, id_titulo, numero_temporada, numero_episodio, titulo_episodio, duracao_min) VALUES
(1, 2, 1, 1, 'Primeira Transmissão',     24),
(2, 2, 1, 2, 'Erro no Ar',                22),
(3, 2, 2, 1, 'Nova Temporada',            25),
(4, 4, 1, 1, 'A Floresta Desperta',       18),
(5, 4, 1, 2, 'O Guardião Perdido',        19),
(6, 6, 1, 1, 'A Primeira Pista',          45),
(7, 6, 1, 2, 'Sombras na Avenida',        42),
(8, 6, 1, 3, 'O Arquivo Secreto',         47);

-- TITULO_GENERO
INSERT INTO titulo_genero (id_titulo, id_genero) VALUES
(1, 1), (1, 4),
(2, 2),
(3, 3),
(4, 5),
(5, 1),
(6, 4), (6, 1),
(7, 6),
(8, 2);

-- PESSOA
INSERT INTO pessoa (id_pessoa, nome, data_nascimento) VALUES
(1, 'João Pedro Alves',   '1978-04-12'),
(2, 'Marina Tavares',     '1985-09-03'),
(3, 'Eduardo Nunes',      '1970-11-20'),
(4, 'Patrícia Gomes',     '1990-02-17'),
(5, 'Renato Dias',        '1965-07-08'),
(6, 'Camila Ferreira',    '1988-12-01'),
(7, 'Otávio Bezerra',     '1975-03-29'),
(8, 'Lucia Marchetti',    '1992-06-14');

-- PARTICIPACAO
INSERT INTO participacao (id_titulo, id_pessoa, papel, personagem) VALUES
(1, 1, 'ator',       'Dr. Henrique'),
(1, 2, 'ator',       'Sofia'),
(1, 5, 'diretor',    NULL),
(2, 4, 'ator',       'Bia'),
(2, 6, 'ator',       'Tom'),
(2, 7, 'diretor',    NULL),
(3, 1, 'ator',       'Agente Vidal'),
(3, 3, 'diretor',    NULL),
(3, 8, 'roteirista', NULL),
(4, 6, 'ator',       'Voz da Raposa'),
(4, 5, 'diretor',    NULL),
(5, 2, 'ator',       'Helena'),
(5, 3, 'ator',       'Marcos'),
(5, 5, 'diretor',    NULL),
(6, 4, 'ator',       'Investigadora Lima'),
(6, 1, 'ator',       'Comissário Reis'),
(6, 8, 'roteirista', NULL),
(7, 7, 'diretor',    NULL),
(8, 6, 'ator',       'Renata'),
(8, 4, 'ator',       'Felipe'),
(8, 7, 'diretor',    NULL);

-- AVALIACAO
INSERT INTO avaliacao (id_avaliacao, id_perfil, id_titulo, nota, comentario, data_avaliacao) VALUES
(1,  1, 1, 5, 'Roteiro excelente, prende do início ao fim.', '2024-01-05'),
(2,  1, 3, 4, 'Ação bem executada.',                          '2024-01-20'),
(3,  3, 1, 4, 'Bom filme de ficção científica.',              '2024-02-02'),
(4,  3, 5, 5, 'Muito emocionante.',                           '2024-02-10'),
(5,  4, 5, 3, 'Ritmo um pouco lento.',                        '2024-02-15'),
(6,  5, 2, 5, 'Série muito divertida.',                       '2024-03-01'),
(7,  5, 8, 4, 'Ótima comédia romântica.',                     '2024-03-05'),
(8,  6, 3, 5, 'Melhor filme de ação do ano.',                 '2024-03-12'),
(9,  6, 6, 4, 'Mistério bem construído.',                     '2024-03-20'),
(10, 8, 6, 5, 'Não consegui parar de assistir.',              '2024-04-01'),
(11, 8, 1, 3, 'Achei previsível.',                            '2024-04-03'),
(12, 2, 7, 5, 'Documentário impressionante.',                 '2024-04-10');

-- HISTORICO_VISUALIZACAO
INSERT INTO historico_visualizacao (id_historico, id_perfil, id_titulo, id_episodio, data_visualizacao, percentual_assistido) VALUES
(1,  1, 1, NULL, '2024-01-04', 100.00),
(2,  1, 3, NULL, '2024-01-18', 100.00),
(3,  3, 1, NULL, '2024-02-01', 95.00),
(4,  3, 5, NULL, '2024-02-09', 100.00),
(5,  4, 5, NULL, '2024-02-14', 60.00),
(6,  5, 2, 1,    '2024-02-25', 100.00),
(7,  5, 2, 2,    '2024-02-26', 100.00),
(8,  5, 8, NULL, '2024-03-04', 100.00),
(9,  6, 3, NULL, '2024-03-11', 100.00),
(10, 6, 6, 6,    '2024-03-18', 100.00),
(11, 6, 6, 7,    '2024-03-19', 80.00),
(12, 8, 6, 6,    '2024-03-29', 100.00),
(13, 8, 6, 7,    '2024-03-30', 100.00),
(14, 8, 6, 8,    '2024-03-31', 45.00),
(15, 2, 7, NULL, '2024-04-09', 100.00),
(16, 7, 4, 4,    '2024-04-12', 100.00),
(17, 7, 4, 5,    '2024-04-13', 70.00);

-- LISTA
INSERT INTO lista (id_lista, id_perfil, nome, data_criacao) VALUES
(1, 1, 'Minha Lista',     '2023-01-15'),
(2, 3, 'Minha Lista',     '2023-03-26'),
(3, 5, 'Minha Lista',     '2023-05-20'),
(4, 6, 'Minha Lista',     '2024-02-05'),
(5, 7, 'Favoritos Kids',  '2024-02-06'),
(6, 8, 'Minha Lista',     '2024-07-01');

-- LISTA_ITEM
INSERT INTO lista_item (id_lista, id_titulo, data_adicao) VALUES
(1, 5, '2023-01-16'),
(1, 6, '2023-02-01'),
(2, 8, '2023-03-27'),
(3, 6, '2023-05-21'),
(3, 3, '2023-06-01'),
(4, 1, '2024-02-06'),
(5, 4, '2024-02-07'),
(6, 6, '2024-07-02'),
(6, 1, '2024-07-03');
