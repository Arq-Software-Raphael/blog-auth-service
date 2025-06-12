#!/bin/sh

# Dê um tempo para o PostgreSQL iniciar completamente antes de continuar.
echo "Aguardando o banco de dados iniciar..."
sleep 10

# Aplica as migrações do banco de dados
echo "Aplicando migrações..."
python manage.py migrate --noinput

# Inicia o servidor Gunicorn
echo "Iniciando o servidor Gunicorn..."
exec gunicorn auth_blog.wsgi:application --bind 0.0.0.0:8000