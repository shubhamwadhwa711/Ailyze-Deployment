#!/bin/bash
docker compose \
    -f docker-compose.yml \
    -f ./compose-files/nginx/docker-compose.nginx.yml \
    -f ./compose-files/others/docker-compose.db.yml \
    -f ./compose-files/backend-chatbot/docker-compose.chatbot.dev.yml \
    -f ./compose-files/frontend/docker-compose.frontend.dev.yml \
    "$@";
