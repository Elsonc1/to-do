# 🚀 Implementação dos Extras Opcionais

Este documento guia a implementação completa dos extras opcionais do projeto.

## 📋 Status de Implementação

### ✅ 1. Busca - PARCIALMENTE IMPLEMENTADO

**Backend:**
- ✅ Busca por título e descrição implementada
- ✅ Filtro por status combinado com busca
- ✅ Endpoint GET /tasks aceita query params `search` e `status`

**Web:**
- ✅ Campo de busca implementado
- ✅ Busca com debounce
- ✅ Integração com backend

**Mobile:**
- ✅ Campo de busca implementado
- ✅ Busca com debounce
- ✅ Integração com backend

**Status:** ✅ **BUSCA COMPLETA**

---

### ⚠️ 2. Autenticação - EM PROGRESSO

**Backend:**
- ⚠️ Estrutura criada (User entity, auth middleware)
- ⚠️ Precisa: Implementar endpoints de auth, hash de senha, rotas protegidas

**Web:**
- ❌ Não implementado

**Mobile:**
- ❌ Não implementado

**Status:** ⚠️ **PARCIAL - Estrutura criada, precisa implementar**

---

### ❌ 3. Upload de Arquivos - NÃO IMPLEMENTADO

**Backend:**
- ❌ Não implementado

**Web:**
- ❌ Não implementado

**Mobile:**
- ❌ Não implementado

**Status:** ❌ **NÃO IMPLEMENTADO**

---

### ❌ 4. Testes Automatizados - NÃO IMPLEMENTADO

**Backend:**
- ❌ Não implementado

**Status:** ❌ **NÃO IMPLEMENTADO**

---

## 🎯 Plano de Implementação

### Fase 1: Completar Busca ✅
- ✅ Backend: Busca implementada
- ✅ Web: Busca implementada  
- ✅ Mobile: Busca implementada

### Fase 2: Autenticação (Em Progresso)

1. **Backend:**
   - Implementar endpoints de registro e login
   - Adicionar hash de senha (bcrypt)
   - Proteger rotas de tarefas com middleware
   - Adicionar JWT

2. **Web:**
   - Criar tela de login
   - Adicionar proteção de rotas
   - Armazenar token

3. **Mobile:**
   - Criar tela de login
   - Adicionar autenticação nas requisições
   - Armazenar token

### Fase 3: Upload de Arquivos

1. **Backend:**
   - Instalar multer
   - Criar endpoint de upload
   - Adicionar campo de arquivo na Task
   - Armazenar arquivos

2. **Web:**
   - Adicionar input de arquivo no formulário
   - Enviar arquivo para backend
   - Exibir arquivo nas tarefas

3. **Mobile:**
   - Adicionar seletor de arquivo
   - Enviar arquivo para backend
   - Exibir arquivo nas tarefas

### Fase 4: Testes

1. **Backend:**
   - Configurar Jest
   - Testes unitários de serviços
   - Testes de integração de endpoints

---

## 📝 Próximos Passos

Para continuar a implementação, siga a ordem:
1. ✅ Busca (já completo)
2. ⚠️ Autenticação (estrutura criada, implementar)
3. ❌ Upload (não iniciado)
4. ❌ Testes (não iniciado)

