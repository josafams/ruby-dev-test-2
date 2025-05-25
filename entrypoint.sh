#!/bin/bash
set -e

# Remove PID file antes de qualquer coisa (evita conflitos com Rails)
rm -f tmp/pids/server.pid

# Corrige problema de mimemagic se ainda estiver em lock errado
if grep -q "mimemagic (0.3.10)" Gemfile.lock; then
  echo "Corrigindo mimemagic para versão suportada (0.3.5)..."
  bundle update mimemagic
fi

# Garante que todas as dependências estão instaladas
echo "Verificando dependências..."
bundle check || bundle install

# Cria e migra banco de dados
echo "Preparando o banco de dados..."
bundle exec rails db:create:all db:migrate

# Inicia o servidor Rails
echo "Iniciando o servidor Rails..."
exec bundle exec rails server -p 3000 -b '0.0.0.0'
