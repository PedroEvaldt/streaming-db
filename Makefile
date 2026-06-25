.PHONY: db-up db-down db-down-full psql-db

db-up:
	docker compose up -d
db-down:
	docker compose down
db-down-full:
	docker compose down -v
psql-db:
	psql -h localhost -p 5433 -U streaming -d streaming
