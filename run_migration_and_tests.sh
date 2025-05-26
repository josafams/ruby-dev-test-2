#!/bin/bash

# Construir a imagem Docker
docker-compose build

# Executar a migração
echo "Executando migração para converter relacionamento 1:N para N:N"
docker-compose run --rm app bundle exec rails db:migrate

# Executar os testes
echo "Executando testes para garantir que tudo funciona."
docker-compose run --rm app bundle exec rails test

