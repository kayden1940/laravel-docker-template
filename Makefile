# Laravel初期インストール
install:
	docker compose exec app composer create-project --prefer-dist "laravel/laravel=" .
	docker compose exec app cp .env.example .env

# 初期インストール
init:
	docker compose exec app php artisan key:generate
	docker compose exec app php artisan storage:link
	docker compose exec app chmod -R 777 storage bootstrap/cache
	@make fresh

# JetStreamのインストール (Inertia)
install-jetstream:
	docker compose exec app composer require laravel/jetstream
	docker compose exec app php artisan jetstream:install inertia

# dockerコンテナ操作
up:
	docker compose up -d
build:
	docker compose build
destroy:
	docker compose down --rmi all --volumes --remove-orphans
exec-app:
	docker compose exec app bash

# Connection MySQL
sql:
	docker compose exec db bash -c 'mysql -u user -pqweqwe laravel'

# Cache Clear
clear:
	docker compose exec app php artisan cache:clear
	docker compose exec app php artisan config:clear
	docker compose exec app php artisan route:clear
	docker compose exec app php artisan view:clear

# マイグレーション実行
migrate:
	docker compose exec app php artisan migrate
fresh:
	docker compose exec app php artisan migrate:fresh --seed

tinker:
	docker compose exec app php artisan tinker

