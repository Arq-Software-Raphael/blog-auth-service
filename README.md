# API de Autenticação com Django REST e JWT

Uma API RESTful completa e robusta para autenticação e gerenciamento de usuários. Construída com Django e Django Rest Framework, esta API utiliza um modelo de usuário customizado com login por email e autenticação baseada em JSON Web Tokens (JWT).

O projeto é totalmente containerizado com Docker e utiliza PostgreSQL como banco de dados, garantindo um ambiente de desenvolvimento e produção consistente e escalável.

---

## Índice

- [Funcionalidades](#-funcionalidades)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Guia de Instalação e Execução](#-guia-de-instalação-e-execução)
- [Testando a API](#-testando-a-api)
- [Documentação dos Endpoints](#-documentação-dos-endpoints)
- [Variáveis de Ambiente](#-variáveis-de-ambiente)
- [Licença](#-licença)

---

## ✨ Funcionalidades

- 🔐 **Autenticação por JWT:** Utiliza `djangorestframework-simplejwt` para gerar tokens de acesso (`access`) e de atualização (`refresh`).
- 👤 **Modelo de Usuário Customizado:** Sistema de login baseado em `email` e senha.
- 📝 **Endpoints Essenciais:** Registro, Login, Logout (com blacklist de tokens) e Refresh de token.
- 🔒 **Rotas Protegidas:** Endpoints que só podem ser acessados por usuários autenticados.
- 🐳 **Ambiente Dockerizado:** Configuração completa com Docker e Docker Compose.
- 🐘 **Banco de Dados PostgreSQL:** Pronto para um ambiente de produção robusto.

---

## 🚀 Tecnologias Utilizadas

- **Backend:** Python 3.11, Django 4.2 (LTS), Django Rest Framework
- **Banco de Dados:** PostgreSQL 16
- **Servidor WSGI:** Gunicorn
- **Containerização:** Docker & Docker Compose

---

## 🔧 Guia de Instalação e Execução

Siga os passos abaixo para configurar e rodar a API em seu ambiente de desenvolvimento.

### Pré-requisitos

- [Docker](https://www.docker.com/get-started/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Guia de Instalação

1.  **Clone o repositório:**

    ```bash
    git clone [https://github.com/seu-usuario/seu-repositorio-backend.git](https://github.com/seu-usuario/seu-repositorio-backend.git)
    cd seu-repositorio-backend
    ```

2.  **Crie o arquivo de ambiente (`.env`):**
    Copie o arquivo de exemplo `.env.example` para um novo arquivo chamado `.env`. Este arquivo conterá suas variáveis de ambiente e segredos.

    ```bash
    cp .env.example .env
    ```

    > **Importante:** Abra o arquivo `.env` e gere uma nova `SECRET_KEY` para garantir a segurança do seu projeto.

3.  **Execute as Migrações do Banco de Dados (Apenas na primeira vez ou para um reset):**
    Para garantir que o banco de dados seja criado corretamente a partir do zero, siga este processo:

    ```bash
    # (Opcional, mas recomendado para um início limpo) Destrói qualquer contêiner ou volume antigo
    docker compose down -v

    # Remove a pasta de migrações local para garantir que não haja conflitos
    rm -rf core/migrations/

    # Cria os novos arquivos de migração a partir dos seus modelos
    docker compose run --rm app python manage.py makemigrations core

    # Aplica as migrações para criar as tabelas no banco de dados
    docker compose run --rm app python manage.py migrate
    ```

4.  **Inicie os serviços com Docker Compose:**
    Este comando irá construir a imagem da aplicação e iniciar os contêineres em segundo plano.
    ```bash
    docker compose up --build -d
    ```

Neste ponto, a API estará rodando e acessível em `http://localhost:8000`.

---

## 🧪 Testando a API

Você pode usar ferramentas como [Insomnia](https://insomnia.rest/), [Postman](https://www.postman.com/) ou o comando `curl` no terminal para interagir com os endpoints.

#### Exemplo 1: Registrar um Novo Usuário

```bash
curl -X POST http://localhost:8000/api/auth/register/ \
-H "Content-Type: application/json" \
-d '{"email": "teste@exemplo.com", "password": "senhaForte123", "password_confirm": "senhaForte123"}'
```

#### Exemplo 2: Fazer Login para Obter Tokens

```bash
curl -X POST http://localhost:8000/api/auth/login/ \
-H "Content-Type: application/json" \
-d '{"email": "teste@exemplo.com", "password": "senhaForte123"}'
```

> A resposta conterá seus tokens `access` e `refresh`. Guarde o token de `access`.

#### Exemplo 3: Acessar uma Rota Protegida

Use o token de `access` obtido no passo anterior para acessar a rota `/me/`.

```bash
# Substitua SEU_TOKEN_DE_ACESSO pelo token que você recebeu
ACCESS_TOKEN="SEU_TOKEN_DE_ACESSO"

curl -X GET http://localhost:8000/api/auth/me/ \
-H "Authorization: Bearer ${ACCESS_TOKEN}"
```

> A resposta deverá ser um JSON com os dados do usuário logado.

---

## 📖 Documentação dos Endpoints

O prefixo base para todos os endpoints é `/api/auth`.

| Rota (Endpoint)    | Método | Descrição                                             | Protegida? |
| :----------------- | :----- | :---------------------------------------------------- | :--------- |
| `/register/`       | `POST` | Registra um novo usuário.                             | Não        |
| `/login/`          | `POST` | Autentica um usuário e retorna tokens JWT.            | Não        |
| `/token/refresh/`  | `POST` | Gera um novo token de acesso usando um refresh token. | Não        |
| `/logout/`         | `POST` | Adiciona o refresh token à blacklist, invalidando-o.  | Sim        |
| `/me/`             | `GET`  | Retorna os dados do usuário autenticado.              | Sim        |
| `/users/<int:pk>/` | `GET`  | Retorna os dados públicos de um usuário específico.   | Sim        |

---

## ⚙️ Variáveis de Ambiente

Configure as seguintes variáveis no seu arquivo `.env` na raiz do projeto.

| Variável            | Descrição                                                       | Exemplo                 |
| :------------------ | :-------------------------------------------------------------- | :---------------------- |
| `SECRET_KEY`        | Chave secreta do Django para segurança criptográfica.           | `'django-insecure-...'` |
| `DEBUG`             | Define o modo de depuração. `True` para dev, `False` para prod. | `True`                  |
| `ALLOWED_HOSTS`     | Hosts/domínios permitidos para a aplicação.                     | `localhost,127.0.0.1`   |
| `POSTGRES_DB`       | Nome do banco de dados no PostgreSQL.                           | `auth_db`               |
| `POSTGRES_USER`     | Nome do usuário do banco de dados.                              | `auth_user`             |
| `POSTGRES_PASSWORD` | Senha do usuário do banco de dados.                             | `auth_password`         |
| `POSTGRES_HOST`     | Host do banco de dados (nome do serviço no Docker).             | `db`                    |
| `POSTGRES_PORT`     | Porta do banco de dados.                                        | `5432`                  |

---

## 📝 Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais informações.
