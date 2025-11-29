# To-Do Application

Aplicação completa de gestão de tarefas composta por Backend API REST, Interface Web e App Mobile.

## Estrutura do Projeto

```
to-do/
├── backend/
├── web/
├── mobile/
└── README.md
```

## Tecnologias Utilizadas

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

### Backend
- CRUD completo de tarefas
- Endpoints RESTful
- Banco de dados PostgreSQL
- Migrações de banco de dados
- Docker Compose para desenvolvimento

### Interface Web
- Listagem de tarefas
- Cadastro e edição
- Alteração de status
- Exclusão
- Filtros por status
- Server-Side Rendering (SSR)
- Interface moderna e responsiva

### App Mobile
- Lista de tarefas
- Cadastro e edição
- Troca de status
- Exclusão
- Filtros por status
- Pull-to-refresh

## API Endpoints

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

## URLs de Acesso

Após iniciar os serviços:

- **Backend API:** http://localhost:3000
- **Interface Web:** http://localhost:3000 (ou porta configurada no Nuxt)
- **Health Check:** http://localhost:3000/health

## Notas Importantes

1. **Backend:** Certifique-se de ter o PostgreSQL rodando ou use Docker Compose
2. **Web:** A URL da API é configurável via variável de ambiente `API_BASE_URL`
3. **Mobile:** Configure a URL da API no arquivo `task_service.dart` conforme seu ambiente:
   - Android Emulator: `http://10.0.2.2:3000`
   - iOS Simulator: `http://localhost:3000`
   - Dispositivo físico: `http://SEU_IP_LOCAL:3000`

## Variáveis de Ambiente

### Backend
Consulte `backend/env.example`

### Web
Consulte `web/env.example`

## Documentação Adicional

### Documentação dos Projetos
- [Backend README](./backend/README.md) - Documentação completa do backend
- [Web README](./web/README.md) - Documentação completa da interface web
- [Mobile README](./mobile/README.md) - Documentação completa do app mobile

## Arquitetura

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