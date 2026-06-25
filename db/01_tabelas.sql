-- =====================================================================
-- Plataforma de Streaming de Filmes e Séries (inspirada na Netflix)
-- Esquema Relacional - tabelas.sql
-- Compatível com PostgreSQL e MySQL (SQL padrão)
-- =====================================================================

-- 1. PLANO: planos de assinatura oferecidos pela plataforma
CREATE TABLE plano (
    id_plano                INTEGER NOT NULL,
    nome                    VARCHAR(30) NOT NULL,
    preco                   NUMERIC(6,2) NOT NULL,
    qtd_telas_simultaneas   INTEGER NOT NULL,
    resolucao_max           VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_plano),
    UNIQUE (nome),
    CHECK (preco >= 0),
    CHECK (qtd_telas_simultaneas > 0),
    CHECK (resolucao_max IN ('SD', 'HD', '4K'))
);

-- 2. USUARIO: conta de assinante (dados de cobrança/login)
CREATE TABLE usuario (
    id_usuario      INTEGER NOT NULL,
    nome            VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL,
    senha_hash      VARCHAR(255) NOT NULL,
    data_cadastro   DATE NOT NULL,
    id_plano        INTEGER NOT NULL,
    PRIMARY KEY (id_usuario),
    UNIQUE (email),
    FOREIGN KEY (id_plano) REFERENCES plano (id_plano)
);

-- 3. PERFIL: perfis individuais dentro de uma conta (estilo "quem está assistindo?")
CREATE TABLE perfil (
    id_perfil       INTEGER NOT NULL,
    id_usuario      INTEGER NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    tipo_conteudo   VARCHAR(10) NOT NULL DEFAULT 'adulto',
    data_criacao    DATE NOT NULL,
    PRIMARY KEY (id_perfil),
    FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario),
    UNIQUE (id_usuario, nome),
    CHECK (tipo_conteudo IN ('infantil', 'adulto'))
);

-- 4. TITULO: catálogo de filmes e séries
CREATE TABLE titulo (
    id_titulo               INTEGER NOT NULL,
    nome                    VARCHAR(150) NOT NULL,
    tipo                    VARCHAR(10) NOT NULL,
    ano_lancamento          INTEGER NOT NULL,
    sinopse                 VARCHAR(1000),
    classificacao_indicativa VARCHAR(3) NOT NULL,
    PRIMARY KEY (id_titulo),
    CHECK (tipo IN ('filme', 'serie')),
    CHECK (ano_lancamento >= 1888),
    CHECK (classificacao_indicativa IN ('L', '10', '12', '14', '16', '18'))
);

-- 5. EPISODIO: episódios de títulos do tipo 'serie'
CREATE TABLE episodio (
    id_episodio         INTEGER NOT NULL,
    id_titulo           INTEGER NOT NULL,
    numero_temporada    INTEGER NOT NULL,
    numero_episodio     INTEGER NOT NULL,
    titulo_episodio     VARCHAR(150),
    duracao_min         INTEGER NOT NULL,
    PRIMARY KEY (id_episodio),
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo),
    UNIQUE (id_titulo, numero_temporada, numero_episodio),
    CHECK (numero_temporada > 0),
    CHECK (numero_episodio > 0),
    CHECK (duracao_min > 0)
);

-- 6. GENERO: gêneros/categorias de conteúdo
CREATE TABLE genero (
    id_genero   INTEGER NOT NULL,
    nome        VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_genero),
    UNIQUE (nome)
);

-- 7. TITULO_GENERO: associação N:N entre titulo e genero
CREATE TABLE titulo_genero (
    id_titulo   INTEGER NOT NULL,
    id_genero   INTEGER NOT NULL,
    PRIMARY KEY (id_titulo, id_genero),
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo),
    FOREIGN KEY (id_genero) REFERENCES genero (id_genero)
);

-- 8. PESSOA: atores, diretores e roteiristas
CREATE TABLE pessoa (
    id_pessoa       INTEGER NOT NULL,
    nome            VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    PRIMARY KEY (id_pessoa)
);

-- 9. PARTICIPACAO: participação de uma pessoa em um título, em um papel específico
CREATE TABLE participacao (
    id_titulo   INTEGER NOT NULL,
    id_pessoa   INTEGER NOT NULL,
    papel       VARCHAR(15) NOT NULL,
    personagem  VARCHAR(100),
    PRIMARY KEY (id_titulo, id_pessoa, papel),
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo),
    FOREIGN KEY (id_pessoa) REFERENCES pessoa (id_pessoa),
    CHECK (papel IN ('ator', 'diretor', 'roteirista'))
);

-- 10. AVALIACAO: nota e comentário de um perfil sobre um título
CREATE TABLE avaliacao (
    id_avaliacao    INTEGER NOT NULL,
    id_perfil       INTEGER NOT NULL,
    id_titulo       INTEGER NOT NULL,
    nota            INTEGER NOT NULL,
    comentario      VARCHAR(500),
    data_avaliacao  DATE NOT NULL,
    PRIMARY KEY (id_avaliacao),
    FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil),
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo),
    UNIQUE (id_perfil, id_titulo),
    CHECK (nota BETWEEN 1 AND 5)
);

-- 11. HISTORICO_VISUALIZACAO: registro de consumo de conteúdo por perfil
CREATE TABLE historico_visualizacao (
    id_historico            INTEGER NOT NULL,
    id_perfil               INTEGER NOT NULL,
    id_titulo               INTEGER NOT NULL,
    id_episodio             INTEGER,
    data_visualizacao       DATE NOT NULL,
    percentual_assistido    NUMERIC(5,2) NOT NULL,
    PRIMARY KEY (id_historico),
    FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil),
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo),
    FOREIGN KEY (id_episodio) REFERENCES episodio (id_episodio),
    CHECK (percentual_assistido BETWEEN 0 AND 100)
);

-- 12. LISTA: listas personalizadas criadas por um perfil (ex.: "Minha Lista")
CREATE TABLE lista (
    id_lista        INTEGER NOT NULL,
    id_perfil       INTEGER NOT NULL,
    nome            VARCHAR(50) NOT NULL,
    data_criacao    DATE NOT NULL,
    PRIMARY KEY (id_lista),
    FOREIGN KEY (id_perfil) REFERENCES perfil (id_perfil),
    UNIQUE (id_perfil, nome)
);

-- 13. LISTA_ITEM: títulos contidos em uma lista (N:N entre lista e titulo)
CREATE TABLE lista_item (
    id_lista    INTEGER NOT NULL,
    id_titulo   INTEGER NOT NULL,
    data_adicao DATE NOT NULL,
    PRIMARY KEY (id_lista, id_titulo),
    FOREIGN KEY (id_lista) REFERENCES lista (id_lista),
    FOREIGN KEY (id_titulo) REFERENCES titulo (id_titulo)
);
