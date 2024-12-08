#!/bin/bash

UNAMEOUT="$(uname -s)"
BASE_DIR=$(
    cd $(dirname $0)
    pwd
)
ASK="\033[95m"
OKBLUE="\033[94m"
OKCYAN="\033[96m"
OKGREEN="\033[92m"
WARNING="\033[93m"
ERROR="\033[91m"
GRAY="\033[90m"
NC="\033[0m"

function display_help {
    printf "my script description\n"
    printf "\n"
    printf "${WARNING}Usage:${NC}\n" >&2
    printf "  bash %s.sh\n" "$0"
    exit
}
function msg { printf "$2%s${NC}\n" "$1"; }
function info { printf "${OKBLUE}i %s${NC}\n" "$1"; }
function ask { printf "${ASK}? %s ${NC}${GRAY}%s${NC} " "$1" "$2"; }
function success { printf "${OKGREEN}✓ %s${NC}\n" "$1"; }
function warning { printf "${WARNING}! %s${NC}\n" "$1"; }
function error { printf "${ERROR}✗ %s${NC}\n" "$1"; }

if [ $# -ge 0 ]; then
    if [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "-help" ] || [ "$1" == "--help" ]; then
        display_help
    fi
fi

#----------------------------------------------------
source "$BASE_DIR/../.env"

if [ "$APP_ENV" = "local" ]; then
    error "ローカル環境での実行は許可されていません。"
    exit 1

elif [ "$APP_ENV" = "development" ] || [ "$APP_ENV" = "develop" ]; then
    echo
    info "=== Deployment to develop"
    echo
    BRANCH=develop

elif [ "$APP_ENV" = "production" ]; then
    printf "${ERROR}\n"
    echo "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    echo "■               DEPLOYMENT TO PRODUCTION                ■"
    echo "■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■"
    printf "${NC}\n"
    BRANCH=main
else
    error "環境変数の読み取りに失敗しました。"
    exit 1
fi

ask "デプロイを実行してもよろしいですか? (branch: ${BRANCH})" "[y/N]"
read -r ANSWER
if [ "$ANSWER" != "y" ]; then
    exit
fi

# ----- git checkout & pull
if [ "$BRANCH" != "$(git branch --show-current)" ]; then
    git checkout ${BRANCH}
fi

git pull

if [ $? = 1 ]; then
    error "git pullに失敗しました。"
    exit 1
fi

# ----- npm ci
ask "npm ci を実行しますか?" "[y/N]"
read -r ANSWER
if [ "$ANSWER" = "y" ]; then
    node -v
    npm ci
fi
if [ $? = 1 ]; then
    error "npm ciに失敗しました。"
    exit 1
fi

# ----- composer update
ask "composer install を実行しますか?" "[y/N]"
read -r ANSWER
if [ "$ANSWER" = "y" ]; then
    composer --version
    composer install
fi
if [ $? = 1 ]; then
    echo "{$RED}[ERROR] composer installに失敗しました{$NC}"
    exit 1
fi

# ----- npm run build
echo
info "=== Start build..."
npm run build
if [ $? = 1 ]; then
    error "ビルドに失敗しました。"
    exit 1
fi

if [ "$(docker-compose exec app php artisan migrate:status --pending | wc -l)" -gt 3 ]; then
    php artisan migrate:status --pending

    ask "未実行のマイグレーションが存在します。マイグレーションを実行しますか?" "[y/N]"
    read -r ANSWER
    if [ "$ANSWER" = "y" ]; then
        php artisan migrate
    fi
else
    info "未実行のマイグレーションはありません。"
fi

echo
info "=== Cache clear..."

php artisan cache:clear &&
    php artisan config:clear &&
    php artisan route:clear &&
    php artisan view:clear

echo
info "Deployment completed!"
