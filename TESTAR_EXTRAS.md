# ✅ Como Testar os Extras Implementados

Guia rápido para testar as funcionalidades extras após a implementação.

---

## 🚀 1. PREPARAÇÃO

### Backend - Instalar Dependências
```bash
cd backend
npm install
```

Isso instalará as novas dependências:
- `jsonwebtoken` - Autenticação
- `bcryptjs` - Hash de senhas  
- `multer` - Upload de arquivos
- `jest`, `ts-jest`, `supertest` - Testes

### Iniciar Backend
```bash
cd backend
npm run dev
```

Ou com Docker:
```bash
cd backend
docker-compose up -d --build
```

### Iniciar Web
```bash
cd web
npm run dev
```

---

## 🔍 2. TESTAR BUSCA

### Web
1. Acesse `http://localhost:3001`
2. Digite no campo de busca no topo da página
3. As tarefas serão filtradas automaticamente (aguarde 500ms)

### Mobile
1. Abra o app
2. Digite no campo de busca no topo
3. As tarefas serão filtradas

---

## 🔐 3. TESTAR AUTENTICAÇÃO

### Web - Passo a Passo

1. **Registrar conta:**
   - Acesse: `http://localhost:3001/register`
   - Preencha:
     - Nome: "Seu Nome"
     - Email: "seu@email.com"
     - Senha: "senha123"
   - Clique em "Criar conta"

2. **Fazer login:**
   - Você será redirecionado automaticamente
   - Ou acesse: `http://localhost:3001/login`
   - Digite email e senha
   - Clique em "Entrar"

3. **Verificar proteção:**
   - Tente acessar `http://localhost:3001` sem estar logado
   - Você será redirecionado para `/login`

4. **Logout:**
   - Clique no botão "Sair" no canto superior direito

### Backend - Testar via API

**Registrar:**
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Teste",
    "email": "teste@example.com",
    "password": "senha123"
  }'
```

**Login:**
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@example.com",
    "password": "senha123"
  }'
```

Você receberá um token JWT no response.

---

## 📎 4. TESTAR UPLOAD DE ARQUIVOS

### Web - Passo a Passo

1. **Criar uma tarefa:**
   - Acesse a página principal (logado)
   - Clique em "+ Nova Tarefa"
   - Preencha título, descrição e salve

2. **Anexar arquivo:**
   - Clique para editar a tarefa criada
   - No modal, veja o campo "Anexar Arquivo"
   - Selecione um arquivo (imagem, PDF, documento)
   - Clique em "Salvar"

3. **Verificar arquivo:**
   - No card da tarefa, você verá um link "📎 Anexo disponível"
   - Clique no link para abrir/download do arquivo

### Tipos de Arquivo Aceitos:
- Imagens: jpg, jpeg, png, gif
- Documentos: pdf, doc, docx, txt

**Limite:** 5MB por arquivo

### Backend - Testar via API

**Upload de arquivo:**
```bash
curl -X POST http://localhost:3000/tasks/{TASK_ID}/upload \
  -F "arquivo=@/caminho/para/seu/arquivo.jpg"
```

Substitua `{TASK_ID}` pelo ID real da tarefa.

---

## 🧪 5. TESTAR TESTES AUTOMATIZADOS

### Rodar testes
```bash
cd backend
npm test
```

### Rodar com watch mode
```bash
npm run test:watch
```

### Rodar com coverage
```bash
npm run test:coverage
```

---

## ✅ 6. CHECKLIST DE TESTES

### Busca
- [ ] Campo de busca aparece na página
- [ ] Busca funciona digitando texto
- [ ] Busca funciona combinada com filtros
- [ ] Debounce funciona (não busca a cada letra)

### Autenticação
- [ ] Página de registro funciona
- [ ] Página de login funciona
- [ ] Redirecionamento funciona
- [ ] Proteção de rotas funciona
- [ ] Logout funciona
- [ ] Token é salvo corretamente

### Upload
- [ ] Input de arquivo aparece no modal
- [ ] Upload funciona
- [ ] Link do arquivo aparece no card
- [ ] Arquivo pode ser baixado/visualizado
- [ ] Validação de tipo de arquivo funciona
- [ ] Limite de tamanho funciona

### Testes
- [ ] Testes rodam sem erros
- [ ] Testes passam

---

## 🐛 Problemas Comuns

### Erro: "Module not found"
```bash
cd backend
npm install
```

### Erro: "relation users does not exist"
As migrações rodam automaticamente. Se não rodarem:
```bash
cd backend
npm run migration:run
```

### Erro: "Porta 3000 já em uso"
Pare o processo ou mude a porta no `.env`

### Erro: "Upload não funciona"
Verifique se a pasta `backend/uploads` existe (é criada automaticamente)

---

## 📝 RESUMO RÁPIDO

```bash
# 1. Instalar dependências do backend
cd backend && npm install

# 2. Iniciar backend
npm run dev
# OU
docker-compose up -d --build

# 3. Iniciar web (em outro terminal)
cd web && npm run dev

# 4. Testar:
# - Busca: digite no campo de busca
# - Auth: acesse /register e /login
# - Upload: edite tarefa e anexe arquivo
# - Testes: npm test no backend
```

---

**Pronto! Tudo deve estar funcionando! 🎉**

