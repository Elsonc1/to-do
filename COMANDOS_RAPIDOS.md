# ⚡ Comandos Rápidos para Testar

## 🚀 PASSO A PASSO RÁPIDO

### 1. Backend - Instalar novas dependências
```bash
cd backend
npm install
```

### 2. Backend - Iniciar servidor
```bash
npm run dev
```

**OU com Docker:**
```bash
docker-compose up -d --build
```

### 3. Web - Iniciar aplicação
```bash
cd ../web
npm run dev
```

### 4. Mobile (opcional)
```bash
cd ../mobile
flutter run
```

---

## ✅ O QUE FOI ADICIONADO

### Novas Dependências no Backend:
- `jsonwebtoken` - Autenticação JWT
- `bcryptjs` - Hash de senhas
- `multer` - Upload de arquivos
- `jest` - Testes automatizados

### Novas Funcionalidades:
- ✅ Busca de tarefas
- ✅ Autenticação (login/registro)
- ✅ Upload de arquivos
- ✅ Testes automatizados

---

## 🧪 TESTAR OS EXTRAS

### Busca
- Acesse a página principal
- Digite no campo de busca

### Autenticação
- Acesse: `http://localhost:3001/register`
- Crie uma conta
- Faça login em: `http://localhost:3001/login`

### Upload
- Edite uma tarefa
- Selecione um arquivo no modal
- Salve

### Testes
```bash
cd backend
npm test
```

---

## 📝 RESUMO DOS COMANDOS

```bash
# 1. Backend
cd backend
npm install          # Instalar novas dependências
npm run dev         # Rodar em desenvolvimento

# 2. Web (em outro terminal)
cd web
npm run dev         # Rodar aplicação web
```

**Pronto!** 🎉

