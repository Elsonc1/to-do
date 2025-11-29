# To-Do Application

Aplicação completa de gestão de tarefas composta por Backend API REST, Interface Web e App Mobile.

## 📁 Estrutura do Projeto

```
to-do/
├── backend/        # API REST (Node.js + Express + TypeScript + TypeORM + PostgreSQL)
├── web/            # Interface Web (Nuxt 4 com SSR)
├── mobile/         # App Mobile (Flutter)
└── README.md       # Este arquivo
```

## 🚀 Tecnologias Utilizadas

### Backend
- Node.js 22+
- Express
- TypeScript
- TypeORM
- PostgreSQL
- Docker

### Web
- Nuxt 4
- Vue 3
- TypeScript
- Tailwind CSS
- Docker

### Mobile
- Flutter
- Dart

## 📋 Funcionalidades

### Backend
- ✅ CRUD completo de tarefas
- ✅ Endpoints RESTful
- ✅ Banco de dados PostgreSQL
- ✅ Migrações de banco de dados
- ✅ Docker Compose para desenvolvimento

### Interface Web
- ✅ Listagem de tarefas
- ✅ Cadastro e edição
- ✅ Alteração de status
- ✅ Exclusão
- ✅ Filtros por status
- ✅ Server-Side Rendering (SSR)
- ✅ Interface moderna e responsiva

### App Mobile
- ✅ Lista de tarefas
- ✅ Cadastro e edição
- ✅ Troca de status
- ✅ Exclusão
- ✅ Filtros por status
- ✅ Pull-to-refresh

## 🛠️ Como Executar

### 📋 Pré-requisitos

**IMPORTANTE:** Antes de começar, você precisa ter instalado:

- **Node.js 22+** (obrigatório para Backend e Web)
- **Docker Desktop** (opcional, para PostgreSQL) OU **PostgreSQL** local
- **Flutter SDK** (opcional, apenas para Mobile)

👉 **Consulte [INSTALL_REQUIREMENTS.md](./INSTALL_REQUIREMENTS.md) para instalar os pré-requisitos**

### ⚡ Início Rápido

👉 **Para um guia rápido passo a passo, consulte [QUICK_START.md](./QUICK_START.md)**

### 1. Backend

Consulte o README específico do backend: [backend/README.md](./backend/README.md)

**Resumo rápido:**
```bash
cd backend
npm install
copy env.example .env
# Configure o .env
npm run dev
```

Ou com Docker:
```bash
cd backend
docker-compose up -d
```

### 2. Interface Web

Consulte o README específico da web: [web/README.md](./web/README.md)

**Resumo rápido:**
```bash
cd web
npm install
copy env.example .env
# Configure o .env se necessário
npm run dev
```

### 3. App Mobile

Consulte o README específico do mobile: [mobile/README.md](./mobile/README.md)

**Resumo rápido:**
```bash
cd mobile
flutter pub get
# Configure a URL da API no task_service.dart
flutter run
```

## 🐛 Problemas?

👉 **Consulte [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) para resolver problemas comuns**

## 📡 API Endpoints

A API backend expõe os seguintes endpoints:

| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/tasks` | Criar nova tarefa |
| GET | `/tasks` | Listar todas as tarefas |
| GET | `/tasks/{id}` | Buscar tarefa específica |
| PUT | `/tasks/{id}` | Atualizar tarefa |
| DELETE | `/tasks/{id}` | Excluir tarefa |

### Modelo de Dados

```typescript
{
  id: string (UUID)
  titulo: string
  descricao?: string
  status: 'pendente' | 'em_andamento' | 'concluida'
  data_criacao: timestamp
  data_conclusao?: timestamp (apenas quando status = concluida)
}
```

## 🌐 URLs de Acesso

Após iniciar os serviços:

- **Backend API:** http://localhost:3000
- **Interface Web:** http://localhost:3000 (ou porta configurada no Nuxt)
- **Health Check:** http://localhost:3000/health

## 📝 Notas Importantes

1. **Backend:** Certifique-se de ter o PostgreSQL rodando ou use Docker Compose
2. **Web:** A URL da API é configurável via variável de ambiente `API_BASE_URL`
3. **Mobile:** Configure a URL da API no arquivo `task_service.dart` conforme seu ambiente:
   - Android Emulator: `http://10.0.2.2:3000`
   - iOS Simulator: `http://localhost:3000`
   - Dispositivo físico: `http://SEU_IP_LOCAL:3000`

## 🔧 Variáveis de Ambiente

### Backend
Consulte `backend/env.example`

### Web
Consulte `web/env.example`

## 📚 Documentação Adicional

### Documentação dos Projetos
- [Backend README](./backend/README.md) - Documentação completa do backend
- [Web README](./web/README.md) - Documentação completa da interface web
- [Mobile README](./mobile/README.md) - Documentação completa do app mobile

### Review e Checklist
- [📋 Review de Escopo](./SCOPE_REVIEW.md) - Análise completa de atendimento ao escopo
- [✅ Checklist de Entrega](./CHECKLIST_ENTREGA.md) - Checklist final antes da entrega

## 🏗️ Arquitetura

### Backend
- Arquitetura em camadas (Controller → Service → Repository)
- ORM TypeORM para gerenciamento de banco de dados
- Migrações para controle de schema

### Web
- Arquitetura baseada em componentes Vue
- Composables para lógica reutilizável
- Server-Side Rendering para melhor SEO e performance

### Mobile
- Arquitetura baseada em widgets Flutter
- Service layer para comunicação com API
- Models para tipagem de dados

## 📄 Licença

MIT

