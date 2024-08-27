#!/bin/bash

UNAMEOUT="$(uname -s)"
BASE_DIR=$(cd $(dirname $0); pwd)
ASK="\033[95m"
OKBLUE="\033[94m"
OKCYAN="\033[96m"
OKGREEN="\033[92m"
WARNING="\033[93m"
ERROR="\033[91m"
GRAY="\033[90m"
NC="\033[0m"

# Define Docker Compose command prefix...
if docker compose &> /dev/null; then
    DOCKER_COMPOSE=(docker compose)
else
    DOCKER_COMPOSE=(docker-compose)
fi

DOCKER_COMPOSE+=(-f "$BASE_DIR"/../docker/docker-compose.yml)

function display_help {
    printf "my script description\n"
    printf "\n"
    printf "${WARNING}Usage:${NC}\n" >&2
    printf "  bash %s.sh\n" "$0"
    exit
}
function msg      { printf "$2%s${NC}\n" "$1"; }
function info     { printf "${OKBLUE}i %s${NC}\n" "$1"; }
function ask      { printf "${ASK}? %s ${NC}${GRAY}%s${NC} " "$1" "$2"; }
function success  { printf "${OKGREEN}✓ %s${NC}\n" "$1"; }
function warning  { printf "${WARNING}! %s${NC}\n" "$1"; }
function error    { printf "${ERROR}✗ %s${NC}\n" "$1"; }

if [ $# -ge 0 ]; then
    if [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "-help" ] || [ "$1" == "--help" ]; then
        display_help
    fi
fi

#----------------------------------------------------

if [ "$1" == "npm" ]; then
  shift 1
  "${DOCKER_COMPOSE[@]}" exec app npm "$@"

elif [ "$1" == "php" ]; then
  shift 1
  "${DOCKER_COMPOSE[@]}" exec app php "$@"

elif [ "$1" == "deploy" ]; then
  bash "$BASE_DIR"/deploy.sh
fi