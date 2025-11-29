# To-Do Backend API

API REST desenvolvida com Node.js, Express, TypeScript e TypeORM para gestão de tarefas.

## Tecnologias Utilizadas

- **Node.js 22+**
- **Express** - Framework web para Node.js
- **TypeScript** - Superset do JavaScript com tipagem estática
- **TypeORM** - ORM para TypeScript e JavaScript
- **PostgreSQL** - Banco de dados relacional
- **Docker** - Containerização da aplicação

## Estrutura do Projeto

```
backend/
├── src/
│   ├── entity/
│   ├── controller/
│   ├── service/
│   ├── routes/
│   ├── migration/
│   ├── data-source.ts
│   └── server.ts
├── dist/
├── Dockerfile
├── docker-compose.yml
└── package.json
```

## Instalação e Configuração

### Pré-requisitos

- Node.js 22 ou superior
- PostgreSQL 15 ou superior
- Docker e Docker Compose (opcional)

### Configuração Manual

1. **Clone o repositório e navegue até a pasta do backend:**
   ```bash
   cd backend
   ```

2. **Instale as dependências:**
   ```bash
   npm install
   ```
   
   **IMPORTANTE:** Se você receber erro `'tsx' não é reconhecido`, significa que as dependências não foram instaladas. Execute `npm install` primeiro!

3. **Configure as variáveis de ambiente:**
   
   Copie o arquivo `.env.example` para `.env` e configure:
   ```env
   PORT=3000
   DB_HOST=localhost
   DB_PORT=5432
   DB_USERNAME=postgres
   DB_PASSWORD=postgres
   DB_DATABASE=todo_db
   NODE_ENV=development
   ```

4. **Crie o banco de dados PostgreSQL:**
   ```sql
   CREATE DATABASE todo_db;
   ```

5. **Execute as migrações:**
   ```bash
   npm run migration:run
   ```

6. **Inicie o servidor em modo desenvolvimento:**
   ```bash
   npm run dev
   ```

   Ou em modo produção:
   ```bash
   npm run build
   npm start
   ```

### Configuração com Docker

1. **Navegue até a pasta do backend:**
   ```bash
   cd backend
   ```

2. **Crie o arquivo `.env` com as configurações:**
   ```env
   PORT=3000
   DB_HOST=db
   DB_PORT=5432
   DB_USERNAME=postgres
   DB_PASSWORD=postgres
   DB_DATABASE=todo_db
   NODE_ENV=production
   ```

3. **Inicie os serviços com Docker Compose:**
   ```bash
   docker-compose up -d
   ```

   Isso irá:
   - Criar e iniciar o container do PostgreSQL
   - Criar e iniciar o container da API
   - Executar as migrações automaticamente

4. **Para parar os serviços:**
   ```bash
   docker-compose down
   ```

## Endpoints da API

### Base URL
```
http://localhost:3000
```

### Endpoints Disponíveis

#### 1. Health Check
- **GET** `/health`
- **Resposta:**
  ```json
  {
    "status": "ok",
    "message": "API está funcionando"
  }
  ```

#### 2. Criar Tarefa
- **POST** `/tasks`
- **Body:**
  ```json
  {
    "titulo": "Título da tarefa",
    "descricao": "Descrição opcional",
    "status": "pendente" // opcional: pendente, em_andamento, concluida
  }
  ```
- **Resposta:** Tarefa criada com `id`, `data_criacao`, etc.

#### 3. Listar Todas as Tarefas
- **GET** `/tasks`
- **Resposta:** Array de tarefas

#### 4. Buscar Tarefa Específica
- **GET** `/tasks/{id}`
- **Resposta:** Tarefa encontrada ou erro 404

#### 5. Atualizar Tarefa
- **PUT** `/tasks/{id}`
- **Body:**
  ```json
  {
    "titulo": "Novo título",
    "descricao": "Nova descrição",
    "status": "concluida"
  }
  ```
- **Resposta:** Tarefa atualizada

#### 6. Excluir Tarefa
- **DELETE** `/tasks/{id}`
- **Resposta:** Status 204 (sem conteúdo)

## Modelo de Dados

### Tarefa (Task)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | UUID | Identificador único |
| `titulo` | String | Título da tarefa (obrigatório) |
| `descricao` | Text | Descrição da tarefa (opcional) |
| `status` | Enum | Status: `pendente`, `em_andamento`, `concluida` |
| `data_criacao` | Timestamp | Data de criação (automático) |
| `data_conclusao` | Timestamp | Data de conclusão (apenas quando status = concluida) |

## Scripts Disponíveis

- `npm run dev` - Inicia o servidor em modo desenvolvimento com hot-reload
- `npm run build` - Compila o TypeScript para JavaScript
- `npm start` - Inicia o servidor em modo produção
- `npm run migration:generate` - Gera uma nova migração
- `npm run migration:run` - Executa as migrações pendentes
- `npm run migration:revert` - Reverte a última migração

## Testando a API

Você pode testar a API usando ferramentas como:
- **Postman**
- **Insomnia**
- **curl**
- **Thunder Client** (VS Code)

### Exemplo com curl:

```bash
# Criar tarefa
curl -X POST http://localhost:3000/tasks \
  -H "Content-Type: application/json" \
  -d '{"titulo":"Minha primeira tarefa","descricao":"Descrição da tarefa"}'

# Listar tarefas
curl http://localhost:3000/tasks

# Buscar tarefa específica
curl http://localhost:3000/tasks/{id}

# Atualizar tarefa
curl -X PUT http://localhost:3000/tasks/{id} \
  -H "Content-Type: application/json" \
  -d '{"status":"concluida"}'

# Excluir tarefa
curl -X DELETE http://localhost:3000/tasks/{id}
```

## Observações

- A API define automaticamente `data_conclusao` quando o status é alterado para `concluida`
- O campo `data_conclusao` é limpo se o status mudar de `concluida` para outro
- O banco de dados é configurado para usar `synchronize: true` apenas em desenvolvimento
- Em produção, sempre use migrações para gerenciar o schema do banco

