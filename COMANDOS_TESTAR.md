# 🚀 Comandos para Testar o Projeto

Guia rápido dos comandos necessários para rodar o projeto após as implementações dos extras.

---

## 📦 1. BACKEND

### Instalar novas dependências
As seguintes dependências foram adicionadas:
- `jsonwebtoken` - Para autenticação JWT
- `bcryptjs` - Para hash de senhas
- `multer` - Para upload de arquivos
- `jest` e relacionados - Para testes

```bash
cd backend
npm install
```

### Executar migrações
Duas novas migrações foram criadas:
- `CreateUsers` - Cria tabela de usuários
- `AddArquivoToTask` - Adiciona campo arquivo na tabela tasks

**Opção 1: Migrações automáticas (recomendado)**
As migrações são executadas automaticamente ao iniciar o servidor.

**Opção 2: Executar manualmente**
```bash
cd backend
npm run migration:run
```

### Rodar o backend

**Desenvolvimento:**
```bash
cd backend
npm run dev
```

**Produção (Docker):**
```bash
cd backend
docker-compose up -d --build
```

**Ver logs do Docker:**
```bash
cd backend
docker-compose logs -f api
```

**Parar Docker:**
```bash
cd backend
docker-compose down
```

---

## 🌐 2. WEB

### Instalar dependências (se necessário)
```bash
cd web
npm install
```

### Rodar a aplicação web
```bash
cd web
npm run dev
```

A aplicação estará disponível em: `http://localhost:3001` (ou outra porta)

---

## 📱 3. MOBILE

### Verificar dependências (já instaladas)
```bash
cd mobile
flutter pub get
```

### Rodar o app
```bash
cd mobile
flutter run
```

---

## ✅ 4. TESTAR OS EXTRAS

### Testar Busca
1. **Web:** Digite no campo de busca na página principal
2. **Mobile:** Digite no campo de busca no topo

### Testar Autenticação

**Backend (via Postman/curl):**
```bash
# Registrar usuário
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@example.com",
    "password": "senha123",
    "nome": "Usuário Teste"
  }'

# Login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@example.com",
    "password": "senha123"
  }'
```

**Web:**
1. Acesse `http://localhost:3001/register`
2. Crie uma conta
3. Faça login em `http://localhost:3001/login`
4. Acesse a página principal (protegida)

### Testar Upload de Arquivos

**Web:**
1. Crie ou edite uma tarefa
2. No modal de edição, selecione um arquivo
3. Salve a tarefa
4. O arquivo aparecerá como link no card

**Backend (via curl):**
```bash
# Upload de arquivo (após criar uma tarefa)
curl -X POST http://localhost:3000/tasks/{TASK_ID}/upload \
  -F "arquivo=@/caminho/para/arquivo.jpg"
```

### Testar Testes
```bash
cd backend
npm test
```

---

## 🔄 5. SE PRECISAR RECRIAR TUDO

### Backend (com Docker)
```bash
cd backend

# Parar containers
docker-compose down

# Remover volumes (apaga banco de dados)
docker-compose down -v

# Reconstruir e iniciar
docker-compose up -d --build

# Ver logs
docker-compose logs -f api
```

### Backend (sem Docker)
```bash
cd backend

# Instalar dependências
npm install

# Criar banco de dados manualmente (se necessário)
# Conectar ao PostgreSQL e criar o banco 'todo_db'

# Rodar migrações
npm run migration:run

# Iniciar servidor
npm run dev
```

---

## 📋 6. CHECKLIST RÁPIDO

- [ ] Backend: `npm install` (novas dependências)
- [ ] Backend: `npm run dev` ou `docker-compose up -d --build`
- [ ] Web: `npm run dev`
- [ ] Mobile: `flutter run` (opcional)

---

## 🐛 Troubleshooting

### Erro: "relation users does not exist"
Execute as migrações:
```bash
cd backend
npm run migration:run
```

### Erro: "Module not found"
Instale as dependências:
```bash
cd backend
npm install
```

### Erro: Porta já em uso
Altere a porta no `.env` ou pare o processo que está usando a porta.

---

## 📝 RESUMO DOS COMANDOS

```bash
# Backend
cd backend
npm install              # Instalar dependências
npm run dev             # Desenvolvimento
# OU
docker-compose up -d --build  # Docker

# Web
cd web
npm install             # Se necessário
npm run dev             # Iniciar

# Mobile
cd mobile
flutter pub get         # Se necessário
flutter run             # Iniciar
```

