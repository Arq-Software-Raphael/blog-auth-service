# Dockerfile

# Use uma imagem base Python oficial e slim.
FROM python:3.9-slim-buster

# Define variáveis de ambiente para Python
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Instala as dependências do projeto
# Copiar o requirements.txt primeiro aproveita o cache do Docker
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o script de entrypoint e dá permissão de execução
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Copia todo o código do projeto para o diretório de trabalho
COPY . .

# Expõe a porta que a aplicação vai rodar
EXPOSE 8000

# Define o entrypoint para ser o nosso script
ENTRYPOINT ["/entrypoint.sh"]

# Comando padrão que será passado para o entrypoint.
# Usamos gunicorn para um servidor mais robusto que o de desenvolvimento.
CMD ["gunicorn", "auth_blog.wsgi:application", "--bind", "0.0.0.0:8000"]