# Docker Tutorial

## Content
1. [Development Enviroment](#development-environment)
2. [Use docker for development](#use-docker-for-development)
3. [Documentation](#documentation)
4. [Github workflow](#github-workflow)
5. [Seed data](#seed-data)
6. [Project detail](#project-detail)
7. [Test](#test)
8. [Services](#services)
9. [Deployment](#deployment)
10. [Makefile](#makefile)

## Development Environment
* Ruby version: 2.5.1
* Rails version: 5.2.1
* Mysql version: 5.7

## Use docker for development

- Install docker CE: https://docs.docker.com/install/linux/docker-ce/ubuntu/

- First time installation:

    `make build`: Build container

    `make up`: Start some background container

    `make seed`: Create + migrate + seed database

    `make dev`: Start rails server

- Note
  ```
    Make sure that all background container was started, run docker ps to check that.
  ```
- Start server with out migrate:
  ```
  make dev
  ```

- Migrate database then start server:
  ```
  make migrate_dev
  ```

- Start rails console
  ```
  make console
  ```

- Create/migrate/reset/seed database:
  ```
  make seed
  ```

- Remove docker containers:
  ```
  make down
  ```

- Update crontab

  By default, to speed up start server, cron service is not running, check file `docker/deploy.sh`, at step "Updating crontab ..." for more information. To update contab, do like this:
  ```
  docker ps
  docker exec -it <rails_container_name> bash
  service cron start
  crontab -l
  whenever --set "environment=development" --update-crontab
  crontab -l
  ```

- Run any command of rails under [Spring](https://github.com/rails/spring)

```
make spring <your_command>
Example: make spring rails c
```

**Note**:

- The folder `docker/database` will be created to hold data for `mysql` container so that database will be persistent even when removing docker containers. This folder will be created with user inside docker container, so use `sudo` before your command or one may change its permission to 777 for ease of use. **DO NOT DO THIS IN PRODUCTION**.
- After changing `Gemfile` or `Gemfile.lock`, it is necessary to rebuild docker containers (`make build` then `make up` then `make dev`).


## Documentation


## Github workflow


## Seed data
```
make up
make seed
```

## Project detail

Tutorial about docker for rails project

## Test

#### Rubocop:

#### Unit test:
Using __rspec__.

Test a file:
```
make rspec <your_path>
Example: make rspec spec/models/post.rb
```

Test all file:
```
make rspecs
```
## Services

## Cron jobs

## Deployment

#### For development environment (Using docker)

Using script /docker/deploy.sh, syntax:
```
docker/deploy.sh <RAILS_ENV>
```
Example:
```
docker/deploy.sh development
```

#### For production environment (Using capistrano)

Updating ...

## Makefile

Convenient Makefile script have been added. `make down`, `make up`... can be used instead of full docker-compose commmands. Please check `Makefile` for more details.
