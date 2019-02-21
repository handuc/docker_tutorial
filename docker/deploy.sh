# Syntax to run this file
# ./deploy.sh development

#! /bin/bash
echo "\n [][][][][]Deploying------> Starting deploy ..."
echo "\n [][][][][]Deploying------> Go to app root ..."
ROOT_PATH=$(cd `dirname $0` && cd .. && pwd)
cd $ROOT_PATH

credentials="config/credentials.yml.enc"
credentials_bak="config/credentials.yml.enc.bak"

if [ -f "$credentials" ]; then
  echo "\n [][][][][]Deploying------> Backing up key on credentials.yml.enc ..."
  cp -f $credentials $credentials_bak
fi

echo "\n [][][][][]Deploying------> Updating source code ..."
git checkout master
git pull origin master

if [ -f "$credentials_bak" ]; then
  echo "\n [][][][][]Deploying------> Recovering key on credentials.yml.enc ..."
  cp -f $credentials_bak $credentials
fi

echo "\n [][][][][]Deploying------> Removing all container ..."
docker-compose down

echo "\n [][][][][]Deploying------> Building all container ..."
sudo docker-compose build
# Current user can not access some files, use `ls -la` to check

echo "\n [][][][][]Deploying------> Starting mysql container ..."
docker-compose up -d mysql
echo "\n [][][][][]Deploying------> Starting spring container ..."
# docker-compose run -e RAILS_ENV=$1 -d spring
echo "\n [][][][][]Deploying------> Starting precompile and migrate ..."
docker-compose run -e RAILS_ENV=$1 --rm app /bin/bash -c "rails assets:precompile && rails db:create && rails db:migrate"

# echo "\n [][][][][]Deploying------> Updating crontab ..."
# docker exec -it  $(docker ps --format='{{.Names}}' | grep "worker") /bin/bash -c "service cron start && whenever --set environment=$1 --update-crontab"

echo "\n [][][][][]Deploying------> Starting rails server ..."
docker-compose run -e RAILS_ENV=$1 -d -p 3000:3000 app rails s

echo "\n \n \n                   *************************** Deploy successfully ! *************************** \n \n \n"
