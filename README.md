# Laravel & Vue & JetStream 環境構築用テンプレート（Docker環境）
Laravel & Vue & JetStream 環境構築用テンプレート

# Installation
## 1. リポジトリの作成・クローン
1. [テンプレートリポジトリ](https://github.com/opipi406/laravel-template/generate)からリポジトリを作成
2. Git clone & change directory

## 2. イメージ・コンテナの作成
```bash
docker compose up -d
```
|container|port|
|-|-|
|nginxコンテナ|localhost:10090|
|phpMyAdminコンテナ|localhost:10099|
|MailHog|localhost:8025|

ユーザ名: root  
パスワード: qweqwe  

## 3. Laravelプロジェクトの構築
### 新規プロジェクトを構築する場合
```
docker compose exec app composer create-project --prefer-dist "laravel/laravel=" .
```
### 既存プロジェクトを利用する場合
```bash
git clone <URL> src
```

## 5. パッケージインストール
```bash
docker compose exec app composer install
```
```bash
docker compose exec app npm install
```

## 6. Laravelの初期設定
```bash
docker compose exec app cp .env.example .env
docker compose exec app php artisan key:generate
docker compose exec app php artisan storage:link
docker compose exec app chmod -R 777 storage bootstrap/cache
```

## 7. DB環境変数を修正
```bash
# MySQL設定
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=qweqwe

# MailHogテスト用のメール設定
MAIL_DRIVER=smtp
MAIL_HOST=mail
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```

## 8. DB初期化 & マイグレーション
```bash
docker compose exec app php artisan migrate:fresh
```
```bash
docker compose exec app php artisan db:seed
```

## 開発用サーバー起動
```bash
docker compose exec app npm run dev
```


# ディレクトリ構成
```
├── docker
│   ├── db  << MySQLコンテナ設定用
│   │   ├── Dockerfile
│   │   ├── data
│   │   └── my.conf
│   ├── php << phpコンテナ設定用
│   │   ├── Dockerfile
│   │   └── php.ini
│   └── web << nginxコンテナ設定用
│       ├── Dockerfile
│       └── default.conf
│
├── docker-compose.yml
└── src << Laravelのソースがここに入る
```

