# 🔧 Solução para Erro de Migração

## ❌ Erro Encontrado
```
error: type "task_status_enum" already exists
```

Isso significa que o banco de dados já tem o tipo enum criado, mas as migrações não estão registradas corretamente.

---

## ✅ SOLUÇÃO - Duas Opções

### Opção 1: Deixar o servidor executar automaticamente (RECOMENDADO)

O servidor já está configurado para executar migrações automaticamente ao iniciar. Apenas inicie o servidor normalmente:

```bash
cd backend
npm run dev
```

O servidor vai:
1. ✅ Conectar ao banco
2. ✅ Executar as migrações automaticamente
3. ✅ Se der erro, apenas avisa mas não impede o servidor de iniciar

---

### Opção 2: Marcar migrações como executadas manualmente

Se quiser executar as migrações manualmente, primeiro marque as já executadas:

```bash
# Conectar ao banco
docker-compose exec db psql -U postgres -d todo_db

# Dentro do psql, inserir na tabela migrations:
INSERT INTO migrations (timestamp, name) VALUES 
  (1712000000000, 'CreateTasks1712000000000'),
  (1712100000000, 'CreateUsers1712100000000'),
  (1712200000000, 'AddArquivoToTask1712200000000');

# Digite \q para sair
```

Depois execute:
```bash
docker-compose exec api npm run migration:run
```

---

## 🚀 SOLUÇÃO RÁPIDA (Recomendada)

**Apenas inicie o servidor normalmente!**

```bash
cd backend
npm run dev
```

As migrações vão rodar automaticamente e, se já existirem, apenas avisar sem quebrar.

---

## ✅ Verificar se está funcionando

1. **Inicie o servidor:**
```bash
npm run dev
```

2. **Verifique os logs** - deve aparecer:
```
✅ Banco de dados conectado com sucesso
🔄 Executando migrações...
✅ Migrações executadas com sucesso
🚀 Servidor rodando na porta 3000
```

3. **Teste a API:**
```bash
curl http://localhost:3000/health
```

---

## 🔍 Se precisar verificar o banco

```bash
# Conectar ao PostgreSQL
docker-compose exec db psql -U postgres -d todo_db

# Ver tabelas
\dt

# Ver tipos
\dT+

# Ver migrações executadas
SELECT * FROM migrations;

# Sair
\q
```

