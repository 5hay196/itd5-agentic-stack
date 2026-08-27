.PHONY: up down restart logs doctor config ps

up:
	bash ./scripts/launch.sh

down:
	docker compose --env-file .env -f docker-compose.yml down

restart:
	docker compose --env-file .env -f docker-compose.yml restart

logs:
	docker compose --env-file .env -f docker-compose.yml logs -f paperclip

ps:
	docker compose --env-file .env -f docker-compose.yml ps

doctor:
	bash ./scripts/doctor.sh

validate:
	bash ./scripts/validate.sh

backup:
	bash ./scripts/backup.sh

config:
	docker compose --env-file .env -f docker-compose.yml config
