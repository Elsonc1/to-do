# 🔧 Corrigir Erro do Nuxt

## ❌ Erro
```
Failed to resolve import "#app-manifest"
```

Este erro geralmente é causado por:
- Cache corrompido do Nuxt/Vite
- Problemas com dependências
- Arquivos de build antigos

---

## ✅ SOLUÇÃO

### Passo 1: Limpar Cache e Build

```bash
cd web

# Remover cache do Nuxt
Remove-Item -Recurse -Force .nuxt -ErrorAction SilentlyContinue

# Remover cache do Vite
Remove-Item -Recurse -Force node_modules/.vite -ErrorAction SilentlyContinue

# Remover node_modules (opcional, se necessário)
# Remove-Item -Recurse -Force node_modules
```

### Passo 2: Reinstalar Dependências (se necessário)

```bash
npm install
```

### Passo 3: Rodar Novamente

```bash
npm run dev
```

---

## 🚀 SOLUÇÃO RÁPIDA (PowerShell)

Execute todos os comandos de uma vez:

```powershell
cd web
Remove-Item -Recurse -Force .nuxt -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force node_modules/.vite -ErrorAction SilentlyContinue
npm run dev
```

---

## 📝 Se Ainda Der Erro

Tente reinstalar dependências completamente:

```bash
cd web
Remove-Item -Recurse -Force .nuxt
Remove-Item -Recurse -Force node_modules
Remove-Item -Force package-lock.json
npm install
npm run dev
```

---

## ✅ O que foi feito

Já removi o cache `.nuxt` e do Vite. Agora tente rodar novamente:

```bash
npm run dev
```

