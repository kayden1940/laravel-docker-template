#!/bin/bash

BASE_DIR=$(
    cd $(dirname $0)
    pwd
)

display_help() {
    printf "Usage: bash bin/generate-model.sh [options]\n"
    printf "\n"
    printf "Options:\n"
    printf "  --model  Generate PHP model classes\n"
    printf "  --ts     Generate TypeScript model classes\n"
    exit
}

# オプションの解析
generate_model=false
generate_ts=false

while [[ $# -gt 0 ]]; do
    case $1 in
    --model)
        generate_model=true
        shift
        ;;
    --ts)
        generate_ts=true
        shift
        ;;
    -h | --help)
        display_help
        ;;
    *)
        echo "不明なオプション: $1"
        exit 1
        ;;
    esac
done

generate_model() {
    php artisan ide-helper:models --write --reset
    ./vendor/bin/pint app/Models
}

generate_ts() {
    php artisan types:generate --outputDir="resources/js/types/models"
    npx prettier --write "$BASE_DIR/../resources/js/types/models/*.ts"

    NUMBER_MODEL_FILE="$BASE_DIR/../resources/js/types/models/number.d.ts"

    # if sed --version >/dev/null 2>&1; then
    #     # GNU
    #     sed -i 's/Number/TellNumber/g' "$NUMBER_MODEL_FILE"
    # else
    #     # BSD
    #     sed -i '' 's/Number/TellNumber/g' "$NUMBER_MODEL_FILE"
    # fi

    php artisan generate:enum-ts
    npx prettier --write "$BASE_DIR/../resources/js/types/enums/*.ts"
}

# モデル生成処理
if $generate_model; then
    generate_model
fi

# TypeScript生成処理
if $generate_ts; then
    generate_ts
fi

# オプションが指定されていない場合は両方の処理を実行
if ! $generate_model && ! $generate_ts; then
    generate_model
    generate_ts
fi
