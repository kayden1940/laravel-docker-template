# Laravel initial installation
install:
	docker compose exec app composer create-project --prefer-dist "laravel/laravel=" .
	docker compose exec app cp .env.example .env

# Initial setup
init:
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan storage:link
	docker compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh

# Install JetStream (Inertia)
install-jetstream:
	docker compose exec app composer require laravel/jetstream
	docker compose exec app php artisan jetstream:install inertia

# Start Docker containers
up:
	docker compose up -d
# Build Docker containers
build:
	docker compose build
# Stop Docker containers
destroy:
	docker compose down --rmi all --volumes --remove-orphans

# Enter the app container
app:
	docker compose exec app bash

# Connect to SQL
sql:
	docker compose exec db bash -c 'mysql -u user -pqweqwe laravel'

# Clear cache
clear:
	docker compose exec app php artisan cache:clear
	docker compose exec app php artisan config:clear
	docker compose exec app php artisan route:clear
	docker compose exec app php artisan view:clear

# Run migrations
migrate:
	docker compose exec app php artisan migrate
# Migrate & refresh
fresh:
	docker compose exec app php artisan migrate:fresh --seed
# Seed the database
seed:
	docker compose exec app php artisan db:seed

# Start Tinker
tinker:
	docker compose exec app php artisan tinker
