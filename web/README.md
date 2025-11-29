# To-Do Web App

Interface web desenvolvida com Nuxt 4 e SSR para gestão de tarefas.

## Tecnologias Utilizadas

- **Nuxt 4** - Framework Vue.js com SSR
- **Vue 3** - Framework JavaScript reativo
- **TypeScript** - Tipagem estática
- **Tailwind CSS** - Framework CSS utilitário
- **Docker** - Containerização da aplicação

## Estrutura do Projeto

```
web/
├── components/
│   ├── TaskCard.vue
│   └── TaskModal.vue
├── composables/
│   └── useTasks.ts
├── pages/
│   └── index.vue
├── layouts/
│   └── default.vue
├── assets/
│   └── css/
│       └── main.css
├── Dockerfile
└── nuxt.config.ts
```

## Instalação e Configuração

### Pré-requisitos

- Node.js 22 ou superior
- Docker e Docker Compose (opcional)

### Configuração Manual

1. **Navegue até a pasta do web:**
   ```bash
   cd web
   ```

2. **Instale as dependências:**
   ```bash
   npm install
   ```

3. **Configure as variáveis de ambiente:**
   
   Copie o arquivo `env.example` para `.env` e configure:
   ```env
   API_BASE_URL=http://localhost:3000
   ```

   Certifique-se de que a URL da API está correta e que o backend está rodando.

4. **Inicie o servidor de desenvolvimento:**
   ```bash
   npm run dev
   ```

   A aplicação estará disponível em `http://localhost:3000`

5. **Para produção:**
   ```bash
   npm run build
   npm run preview
   ```

### Configuração com Docker

1. **Navegue até a pasta do web:**
   ```bash
   cd web
   ```

2. **Crie o arquivo `.env` com as configurações:**
   ```env
   API_BASE_URL=http://localhost:3000
   ```

   **Nota:** Se estiver usando Docker Compose para o backend, ajuste a URL conforme necessário (ex: `http://backend:3000` ou configure um proxy reverso).

3. **Build da imagem:**
   ```bash
   docker build -t todo-web .
   ```

4. **Execute o container:**
   ```bash
   docker run -p 3000:3000 --env-file .env todo-web
   ```

## Acessando a Aplicação

Após iniciar a aplicação, acesse:

```
http://localhost:3000
```

## Funcionalidades

- Listagem de tarefas
- Cadastro de novas tarefas
- Edição de tarefas existentes
- Alteração de status (pendente, em andamento, concluída)
- Exclusão de tarefas
- Filtros por status
- Interface responsiva e moderna

## Scripts Disponíveis

- `npm run dev` - Inicia o servidor de desenvolvimento com hot-reload
- `npm run build` - Compila a aplicação para produção
- `npm run generate` - Gera uma versão estática
- `npm run preview` - Preview da versão de produção

## Observações

- A aplicação utiliza Server-Side Rendering (SSR) por padrão
- A URL da API backend é configurável através da variável `API_BASE_URL`
- Certifique-se de que o backend está rodando antes de iniciar a aplicação web

