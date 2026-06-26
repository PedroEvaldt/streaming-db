# Streaming DB

Trabalho de **Fundamentos de Banco de Dados** (UFRGS, Profa. Karin Becker) —
Parte 3. Programa que acessa uma base de dados de uma plataforma de streaming
de filmes e séries (inspirada na Netflix).

As Partes 1 e 2 (modelagem relacional, dicionário de dados, instâncias e as 10
consultas + visão) estão em `db/`.

## Stack

- **SGBD:** PostgreSQL 16 (em Docker).
- **Backend:** Go com `database/sql` + driver `pgx/v5/stdlib`. HTTP via
  `net/http` puro (sem framework).
- **Frontend:** em `frontend/` (a definir pelo parceiro).

## Estrutura

```
streaming-db/
├── docker-compose.yml          Postgres + volumes
├── Makefile                    atalhos (db-up, db-down, psql-db)
├── db/
│   ├── 01_tabelas.sql          esquema
│   ├── 02_instancias.sql       dados de exemplo
│   ├── 03_view.sql             vw_avaliacao_perfil_titulo
│   └── consultas.sql           as 10 consultas (documentação canônica)
├── backend/
│   ├── main.go                 entrypoint, monta mux e sobe servidor
│   ├── conexao.go              AbrirConexao + CloseDB
│   ├── consultas.go            10 funções de consulta + helper executarScan
│   ├── handlers.go             10 HTTP handlers + responderJSON
│   ├── middleware.go           CORS + logging
│   ├── config/config.go        credenciais/porta do banco
│   └── queries/01..10.sql      SQL de cada consulta (carregado via //go:embed)
└── frontend/
```

## Pré-requisitos

- Docker + Docker Compose
- Go 1.22+ (usa `ServeMux` com pattern matching e generics)

## Como rodar

### 1. Subir o banco

```bash
make db-up
# ou: docker compose up -d
```

Na primeira inicialização, o Postgres executa `01_tabelas.sql`,
`02_instancias.sql` e `03_view.sql` automaticamente. Para forçar uma
reinicialização limpa:

```bash
make db-down-full   # apaga o volume
make db-up
```

### 2. Conectar via psql (opcional)

```bash
make psql-db
# senha: streaming
```

### 3. Subir o backend

```bash
cd backend
go run .
```

A API sobe em `http://localhost:8080`.

## Rotas da API

| Método | Rota            | Parâmetros             |
| ------ | --------------- | ---------------------- |
| GET    | `/consultas/1`  | —                      |
| GET    | `/consultas/2`  | `min_avaliacoes` (int) |
| GET    | `/consultas/3`  | —                      |
| GET    | `/consultas/4`  | —                      |
| GET    | `/consultas/5`  | —                      |
| GET    | `/consultas/6`  | `id_titulo` (int)      |
| GET    | `/consultas/7`  | —                      |
| GET    | `/consultas/8`  | —                      |
| GET    | `/consultas/9`  | —                      |
| GET    | `/consultas/10` | —                      |

Resposta sempre em JSON. Códigos:

- `200 OK` — sucesso.
- `400 Bad Request` — parâmetro faltando ou inválido (rotas parametrizadas).
- `405 Method Not Allowed` — método diferente de GET (automático do mux).
- `500 Internal Server Error` — falha na consulta ao banco.

### Exemplos

```bash
# sem parâmetro
curl -s http://localhost:8080/consultas/1 | jq

# parametrizado (C2 e C6)
curl -s 'http://localhost:8080/consultas/2?min_avaliacoes=1' | jq
curl -s 'http://localhost:8080/consultas/6?id_titulo=6' | jq

# erro proposital (400)
curl -i 'http://localhost:8080/consultas/6?id_titulo=abc'
```

## Decisões de design

- **Sem ORM.** Conexão, comandos e leitura de resultados ficam visíveis
  (`database/sql` + `pgx` como driver). Não usamos `pgx` no modo nativo
  para manter o código padronizado.
- **SQL fora do código Go.** Cada consulta vive em `backend/queries/NN.sql` e
  é embedada no binário via diretiva `//go:embed` — sem concatenação de strings.
- **Prepared statements.** Consultas com parâmetro (C2 e C6) usam
  `db.Prepare` → `stmt.Query($N)`, conforme o enunciado.
- **Helper genérico `executarScan`.** As 8 consultas sem parâmetro compartilham
  o ciclo `Query → rows.Next → Scan → rows.Err` através de uma função genérica
  que recebe um `scanner` por callback. As parametrizadas (C2 e C6) escrevem o
  ciclo inline para destacar o uso de `Prepare`.
- **Closure para injetar `*sql.DB`.** Cada handler é uma função
  `handlerConsultaN(db) http.HandlerFunc`, evitando estado global.
- **Middleware de logging** loga `method`, `path`, `status` e `duracao` por
  request (status capturado via wrapper de `http.ResponseWriter`).
- **CORS** permissivo (`*`) para desenvolvimento, com tratamento de preflight
  (`OPTIONS` → `204`).

## Configuração

Credenciais do banco em `backend/config/config.go`. Para mudar host/porta/usuário,
edite o arquivo (não há `.env`).

## Encerramento

`Ctrl+C` interrompe o servidor. O `defer CloseDB` roda no caminho normal de
saída do `main`; em interrupção forçada, o sistema operacional reclama as
conexões.
