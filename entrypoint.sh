#!/bin/sh

# entrypoint.sh

# Espera o banco de dados ficar pronto (opcional, mas recomendado)
# netcat (nc) pode não estar disponível, pode ser necessário instalar (apt-get update && apt-get install -y netcat)
# echo "Aguardando o PostgreSQL iniciar..."
# while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
#   sleep 0.1
# done
# echo "PostgreSQL iniciado."

# Aplica as migrações do banco de dados
echo "Aplicando migrações do banco de dados..."
python manage.py migrate --noinput

# Coleta arquivos estáticos (se necessário)
# echo "Coletando arquivos estáticos..."
# python manage.py collectstatic --noinput

# Inicia o servidor passado como CMD no Dockerfile (gunicorn)
# O `exec "$@"` substitui o processo do shell pelo comando,
# permitindo que o gunicorn receba sinais do Docker corretamente.
echo "Iniciando o servidor..."
exec "$@"