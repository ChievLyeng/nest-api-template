# save system vars
VARS_OLD := $(.VARIABLES)

CI_REGISTRY          ?= ghcr.io
CI_PROJECT_NAMESPACE ?= chievlyeng
CI_PROJECT_NAME      ?= app-room-rental-api
CI_COMMIT_REF_NAME   ?= dev

# image and tag
TAG=$(CI_COMMIT_REF_NAME)
IMG=$(CI_REGISTRY)/$(CI_PROJECT_NAMESPACE)

COMPOSE_PROJECT_NAME ?=$(CI_PROJECT_NAME)

#### --- end of fixed section --- ####
######################################

# --- CORE APPLICATION ---
NODE_ENV            = development
APP_PORT            = 3000

# --- DATABASE CONFIGURATION ---
DB_HOST=localhost
DB_PORT=5432
DB_NAME=app_room_rental
DB_USER=myuser
DB_PASSWORD=mypassword



