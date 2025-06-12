
FROM python:3.11-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Instala as dependências do projeto
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o script de entrypoint e dá permissão de execução
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Copia todo o código do projeto para o diretório de trabalho
COPY . .

# Define o entrypoint para ser o nosso script
ENTRYPOINT ["/entrypoint.sh"]

# Comando padrão que será passado para o entrypoint.
CMD ["gunicorn", "auth_blog.wsgi:application", "--bind", "0.0.0.0:8000"]