# API de Autenticação com Django REST e JWT

Uma API RESTful completa e robusta para autenticação e gerenciamento de usuários. Construída com Django e Django Rest Framework, esta API utiliza um modelo de usuário customizado com login por email e autenticação baseada em JSON Web Tokens (JWT).

O projeto é totalmente containerizado com Docker e utiliza PostgreSQL como banco de dados, garantindo um ambiente de desenvolvimento e produção consistente e escalável.

---

## ✨ Funcionalidades Principais

- 🔐 **Autenticação por JWT:** Geração de tokens de acesso (`access`) e atualização (`refresh`) usando `djangorestframework-simplejwt`.
- 👤 **Modelo de Usuário Customizado:** Sistema de login baseado em `email` e senha, sem a necessidade de `username`.
- 📝 **Endpoints Essenciais:**
  - Registro de novos usuários.
  - Login para obter tokens.
  - Logout com blacklist de tokens de atualização.
  - Endpoint para obter um novo token de acesso (`refresh`).
- 🔒 **Rotas Protegidas:** Endpoints que exigem um token de acesso válido para serem acessados.
- 🐳 **Ambiente Dockerizado:** Configuração completa com Docker e Docker Compose para fácil instalação e deploy.
- 🐘 **Banco de Dados PostgreSQL:** Pronto para um ambiente de produção.

---

## 🚀 Tecnologias Utilizadas

![Python](https://img.shields.io/badge/Python-3.9-3776AB?style=for-the-badge&logo=python)
![Django](https://img.shields.io/badge/Django-4.2-092E20?style=for-the-badge&logo=django)
![Django REST Framework](https://img.shields.io/badge/DRF-3.14-A30000?style=for-the-badge&logo=django)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13-336791?style=for-the-badge&logo=postgresql)
![Docker](https://img.shields.io/badge/Docker-20.10-2496ED?style=for-the-badge&logo=docker)

---

## 🔧 Configuração do Ambiente

Siga os passos abaixo para configurar e rodar a API em seu ambiente de desenvolvimento.

### Pré-requisitos

- [Docker](https://www.docker.com/get-started/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Guia de Instalação

1.  **Clone o repositório:**

    ```bash
    git clone [https://github.com/seu-usuario/seu-repositorio.git](https://github.com/seu-usuario/seu-repositorio.git)
    cd seu-repositorio
    ```

2.  **Crie o arquivo de ambiente (`.env`):**
    Copie o arquivo de exemplo `.env.example` para um novo arquivo chamado `.env`. Este arquivo conterá suas variáveis de ambiente e segredos.

    ```bash
    cp .env.example .env
    ```

    > **Importante:** Abra o arquivo `.env` e gere uma nova `SECRET_KEY` para garantir a segurança do seu projeto.

3.  **Execute as Migrações do Banco de Dados (Apenas na primeira vez):**
    Para garantir que o banco de dados seja criado corretamente a partir do zero, é recomendado seguir este processo de "reset limpo":

    ```bash
    # (Opcional) Destrói qualquer contêiner ou volume antigo
    docker compose down -v

    # Remove a pasta de migrações local para garantir que não haja conflitos
    rm -rf core/migrations/

    # Cria os novos arquivos de migração a partir dos seus modelos
    docker compose run --rm --entrypoint "" app python manage.py makemigrations core

    # Aplica as migrações para criar as tabelas no banco de dados
    docker compose run --rm --entrypoint "" app python manage.py migrate
    ```

4.  **Inicie os serviços com Docker Compose:**
    Este comando irá construir a imagem da aplicação e iniciar os contêineres do Django e do PostgreSQL em segundo plano.
    ```bash
    docker compose up --build -d
    ```

Neste ponto, a API estará rodando e acessível em `http://localhost:8000`.

---

## 🧪 Testando a API

Você pode usar ferramentas como [Insomnia](https://insomnia.rest/), [Postman](https://www.postman.com/) ou `curl` para interagir com os endpoints.

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

| Rota (Endpoint)    | Método | Descrição                                                    | Protegida? | Corpo (Payload) Exemplo                                                       |
| :----------------- | :----- | :----------------------------------------------------------- | :--------- | :---------------------------------------------------------------------------- |
| `/register/`       | `POST` | Registra um novo usuário.                                    | Não        | `{"email": "user@example.com", "password": "...", "password_confirm": "..."}` |
| `/login/`          | `POST` | Autentica um usuário e retorna tokens JWT.                   | Não        | `{"email": "user@example.com", "password": "..."}`                            |
| `/token/refresh/`  | `POST` | Gera um novo token de acesso usando um token de atualização. | Não        | `{"refresh": "seu_refresh_token"}`                                            |
| `/logout/`         | `POST` | Adiciona o token de atualização à blacklist, invalidando-o.  | Sim        | `{"refresh_token": "seu_refresh_token"}`                                      |
| `/me/`             | `GET`  | Retorna os dados do usuário autenticado.                     | Sim        | N/A                                                                           |
| `/users/<int:pk>/` | `GET`  | Retorna os dados públicos de um usuário específico.          | Sim        | N/A                                                                           |

---

## ⚙️ Variáveis de Ambiente

Configure as seguintes variáveis no seu arquivo `.env`.

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
