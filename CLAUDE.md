# CLAUDE.md — Instruções do Projeto

## Sobre este projeto

Parte 3 do trabalho de **Fundamentos de Banco de Dados** (Profa. Karin Becker).
É um programa que acessa uma base de dados de uma **plataforma de streaming de
filmes e séries** (inspirada na Netflix). As Partes 1 e 2 (modelagem relacional,
dicionário de dados, instâncias e as 10 consultas + visão) já estão concluídas e
estão em `db/`.

Trabalho feito em dupla:

- **Autor (eu):** conhecimento em Go. Responsável principal pela camada de acesso ao banco.
- **Parceiro:** conhecimento em front-end (JS/React). Responsável principal pela interface.
- **Atenção:** o vídeo de entrega exige que **os dois** expliquem o código de acesso
  ao banco. Logo, ambos precisam dominar a camada Go, não só quem a escreveu.

---

## ⚠️ Objetivo pedagógico — LEIA ANTES DE RESPONDER

O autor quer **aprender fazendo**. A regra principal deste projeto é:

> **Não escreva código pronto, a menos que eu peça explicitamente.**

### O que fazer (modo padrão)

- Explicar conceitos, comparar abordagens e recomendar a melhor com justificativa.
- Apontar **quais funções da biblioteca** usar (ex.: `db.Prepare`, `rows.Scan`) e
  para que servem, deixando-me escrevê-las.
- Mostrar como organiar os proximos passos em relação a arquivos, quais arquivos criar
  onde colocar as funções futuras.
- Fazer perguntas que me guiem ao raciocínio em vez de entregar a resposta.
- **Revisar** código que eu escrever: apontar bugs, riscos, melhorias, e explicar o porquê.
- Ajudar a depurar **explicando o erro** e como investigá-lo — não despejando a correção.
- Quando um exemplo for útil, preferir um trecho pequeno e ilustrativo (e explicá-lo
  linha a linha) a uma implementação completa.

### O que NÃO fazer

- Não entregar arquivos `.go` completos prontos para colar sem eu pedir.
- Não "adiantar" as próximas etapas escrevendo o código delas.
- Não resolver o exercício por mim quando eu estiver travado — me dar a pista seguinte,
  a não ser que seja pedido por mim.

### Quando eu PEDIR código

Se eu disser algo como "escreve isso pra mim", "me dá o código completo de X" ou
"gera o esqueleto", aí sim escreva — mas **comente bem**, porque vou precisar
explicar tudo no vídeo.

---

## Stack (decidida)

- **SGBD:** PostgreSQL (rodando via Docker).
- **Backend:** Go usando a biblioteca padrão `database/sql` + driver **`pgx`**.
  Servidor HTTP com `net/http` **puro** (sem framework).
- **Frontend:** a definir pelo parceiro (HTML/JS vanilla ou React). Mantê-lo simples.

---

## Restrições do enunciado (não violar)

1. **Proibido framework que obscureça a conexão com o banco.** Nada de ORM (ex.: GORM).
   A conexão, os comandos e a leitura de resultados têm que estar visíveis e explicáveis.
2. **Consultas com parâmetro (mínimo 2)** devem usar **prepared statements / bind
   variables de verdade** (`db.Prepare` → `stmt.Query`, placeholders `$1, $2`).
   **Nunca** montar a consulta concatenando strings com os parâmetros.
3. As **10 consultas** da Parte 2 devem executar e mostrar resultados.
4. SQL deve ser **padrão** (roda em PostgreSQL).
5. A base já está populada para retornar resultado em todos os cenários — não alterar
   as instâncias sem necessidade.
6. Interface simples é suficiente; **interface sofisticada não é valorizada**.

---

## Estrutura de pastas (alvo)

```
trabalho-fbd/
├── CLAUDE.md
├── ROADMAP.md
├── docker-compose.yml
├── db/
│   ├── tabelas.sql
│   └── instancias.sql
├── backend/
│   ├── go.mod
│   ├── main.go
│   ├── conexao.go
│   └── consultas.go
└── frontend/
    └── (a definir)
```

## Consultas que serão parametrizadas (candidatas)

- **Consulta 6 (TODOS):** trocar o `id_titulo = 6` fixo por parâmetro.
- **Consulta 2 (GROUP BY + HAVING):** parametrizar `tipo_conteudo` e/ou o limite do `HAVING`.
