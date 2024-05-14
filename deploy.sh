#!/bin/bash

helpFunction()
{
    echo ""
    echo "Usage: $0"
    echo "Command 1 prod / stage/ dev"
    echo "Command 2 build / pull / push / up / down"
    exit 1
}

if [ -z "$1" ]
then
    echo "You must give the env and command"
    helpFunction
fi

if [ "$1" = "prod" ]
then
    export $(grep -v '^#' ./.env.prod | xargs)
elif [ "$1" = "stage" ]
then
    export $(grep -v '^#' ./.env.stage | xargs)
elif [ "$1" = "dev" ]
then
    export $(grep -v '^#' ./.env | xargs)
fi

if [ "$2" = "build" ]
then
    docker-compose \
        -f docker-compose.yml \
        -f ./compose-files/backend-oneclickinsight/docker-compose.oneclickinsight.dev.yml \
        -f ./compose-files/frontend/docker-compose.frontend.dev.yml \
        "$2";
        
    docker push ailyzeregistery.azurecr.io/ailyze-backend:"$BACKENDTAG"
    docker push ailyzeregistery.azurecr.io/ailyze-frontend:"$FRONTENDTAG"

elif [ "$2" = "up" ]
then
    docker pull ailyzeregistery.azurecr.io/ailyze-backend:"$BACKENDTAG"
    docker pull ailyzeregistery.azurecr.io/ailyze-frontend:"$FRONTENDTAG"

    docker-compose \
        -f docker-compose.yml \
        -f ./compose-files/backend-oneclickinsight/docker-compose.oneclickinsight.dev.yml \
        -f ./compose-files/backend-chatbot/docker-compose.chatbot.dev.yml \
        -f ./compose-files/others/docker-compose.celery.yml \
        -f ./compose-files/others/docker-compose.redis.yml \
        -f ./compose-files/others/docker-compose.rabbitmq.yml \
        -f ./compose-files/frontend/docker-compose.frontend.dev.yml \
        -f ./compose-files/nginx/docker-compose.nginx.yml \
        "$2" -d

elif [ "$2" != "build" ] && [ "$2" != "up" ]
then
    docker-compose \
        -f docker-compose.yml \
        -f ./compose-files/backend-oneclickinsight/docker-compose.oneclickinsight.dev.yml \
        -f ./compose-files/backend-oneclickinsight/docker-compose.oneclickinsight.dev.yml \
        -f ./compose-files/others/docker-compose.celery.yml \
        -f ./compose-files/others/docker-compose.redis.yml \
        -f ./compose-files/others/docker-compose.rabbitmq.yml \
        -f ./compose-files/frontend/docker-compose.frontend.dev.yml \
        -f ./compose-files/nginx/docker-compose.nginx.yml \
        "$2"

fi

echo "Build with env = ${ENVIRONMENT}"
exit 0
