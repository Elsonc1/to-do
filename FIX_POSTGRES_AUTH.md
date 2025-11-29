# 🔧 Corrigir Erro de Autenticação PostgreSQL

## ❌ Erro Encontrado
```
error: autenticação do tipo senha falhou para o usuário "postgres"
```

Este erro ocorre quando:
1. O PostgreSQL não está rodando
2. A senha está incorreta
3. Está tentando conectar ao PostgreSQL local ao invés do Docker

---

## ✅ SOLUÇÃO

### Opção 1: Usar Docker (Recomendado)

1. **Parar qualquer PostgreSQL local** (se houver)

2. **Iniciar o Docker Compose:**
```bash
cd backend
docker-compose up -d
```

3. **Aguardar o banco ficar pronto** (alguns segundos)

4. **Verificar se está rodando:**
```bash
docker-compose ps
```

5. **Agora rodar as migrações:**
```bash
npm run migration:run
```

### Opção 2: Usar PostgreSQL Local

Se você tem PostgreSQL instalado localmente:

1. **Verificar se está rodando:**
```bash
# Windows - PowerShell
Get-Service -Name postgresql*

# Ou verificar na porta
netstat -an | findstr 5432
```

2. **Verificar suas credenciais locais**

3. **Atualizar o arquivo `.env`** com as credenciais corretas:
```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=seu_usuario
DB_PASSWORD=sua_senha
DB_DATABASE=todo_db
```

4. **Criar o banco de dados** (se não existir):
```sql
CREATE DATABASE todo_db;
```

5. **Rodar migrações:**
```bash
npm run migration:run
```

---

## 🚀 SOLUÇÃO RÁPIDA (Usando Docker)

```bash
# 1. Parar tudo que está rodando
cd backend
docker-compose down

# 2. Iniciar apenas o banco de dados
docker-compose up -d db

# 3. Aguardar alguns segundos para o banco iniciar

# 4. Verificar se está rodando
docker-compose ps

# 5. Rodar migrações
npm run migration:run

# 6. Iniciar o servidor
npm run dev
```

---

## 🔍 Verificar Status do Docker

```bash
docker-compose ps
```

Deve mostrar algo como:
```
NAME           STATUS          PORTS
todo-postgres  Up (healthy)    0.0.0.0:5432->5432/tcp
```

---

## 📝 Notas Importantes

1. **O Docker Compose já cria o banco automaticamente** com as credenciais configuradas
2. **As migrações podem ser executadas automaticamente** ao iniciar o servidor (`npm run dev`)
3. **Se usar PostgreSQL local**, certifique-se que as credenciais no `.env` estão corretas

---

## ⚠️ Se ainda der erro

1. **Limpar volumes do Docker** (cuidado: apaga dados):
```bash
docker-compose down -v
docker-compose up -d
```

2. **Verificar logs do PostgreSQL:**
```bash
docker-compose logs db
```

3. **Testar conexão manual:**
```bash
docker-compose exec db psql -U postgres -d todo_db
```

