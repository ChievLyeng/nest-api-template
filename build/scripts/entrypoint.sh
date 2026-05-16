#!/bin/bash
# Sabay Docker entrypoint.sh

check_env() {
  local var="$1"

  if [[ ! "${!var:-}" ]] ; then
    echo >&2 "ERROR: $var is not set"
    exit 1
  else
    if [[ ${NODE_ENV} != "production" ]]; then
      echo "INIT $var : ${!var}"
    fi
  fi
}

envs=(
  NODE_ENV
  APP_PORT
  DB_PORT
  DB_NAME
  DB_USER
  DB_PASSWORD
)

case ${1} in
  app:start)
    source /bin/secrets2env.sh
    # check if all envs are set
    for e in "${envs[@]}"; do
      check_env "$e"
    done

    if [[ ${NODE_ENV} == "development" ]]; then
      # ready to start server with nodemon
      echo "INIT: starting web service for development(nodemon)"
      exec npm run dev
    else
      # ready to start server
      echo "INIT: starting web service production"
      exec npm run start:prod
    fi
  ;;

  worker:start)
    source /bin/secrets2env.sh
    # check if all envs are set
    for e in "${envs[@]}"; do
      check_env "$e"
    done

    if [[ ${NODE_ENV} == "development" ]]; then
      echo "INIT: starting rabbitmq worker for development"
      exec npm run start:worker:dev
    else
      echo "INIT: starting rabbitmq worker production"
      exec npm run start:worker:prod
    fi
  ;;

  cron:start)
    source /bin/secrets2env.sh
    # check if all envs are set
    for e in "${envs[@]}"; do
      check_env "$e"
    done

    if [[ ${NODE_ENV} == "development" ]]; then
      echo "INIT: starting cron for development"
      exec npm run start:cron:dev
    else
      echo "INIT: starting cron production"
      exec npm run start:cron:prod
    fi
  ;;

  app:help)
    echo "Available options:"
    echo " app:start  - Starts the server (default)"
    echo " worker:start - Starts the RabbitMQ worker"
    echo " [command]  - Execute the specified command, eg. bash."
  ;;

  *)
    exec "$@"
  ;;

esac
