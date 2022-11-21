# Laravel & Vue & JetStream 環境構築用テンプレート（Docker環境）
Laravel & Vue & JetStream（Inertia）環境構築用テンプレート

# Installation
## 1. リポジトリの作成・クローン
1. [テンプレートリポジトリ](https://github.com/opipi406/laravel-template/generate)からリポジトリを作成
2. Git clone & change directory

## 2. イメージ・コンテナの作成
```bash
docker compose up -d
```

nginxコンテナ : `localhost:10090`  
phpMyAdminコンテナ : `localhost:10099`  

MySQLに「user」のアカウントが無い場合、`localhost:10099`に接続して以下のユーザーアカウントを作成  

ユーザ名: user  
パスワード: qweqwe  

## 3. 新規Laravelプロジェクトの作成 or 既存のLaravelプロジェクトのクローン
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
npm --prefix src install src
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
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=user
DB_PASSWORD=qweqwe
```

## 8. DB初期化 & マイグレーション
```bash
docker compose exec app php artisan migrate:fresh
```

## 開発用サーバー起動
```bash
cd src
npm run dev
```


# Directories
```
├── Makefile
├── README.md
├── container
│   ├── db  <-- MySQLコンテナ設定用
│   │   ├── Dockerfile
│   │   ├── data
│   │   └── my.conf
│   ├── php <-- phpコンテナ設定用
│   │   ├── Dockerfile
│   │   └── php.ini
│   └── web <-- nginxコンテナ設定用
│       ├── Dockerfile
│       └── default.conf
│
├── docker compose.yml
└── src <-- Laravelのソースがここに入る
```

