# Local Development Setup - apps-backend

## 🚀 Quick Start (5 minutos)

### 1. Clonar repositorio
```bash
git clone https://github.com/ATD-S-L/apps-backend.git
cd apps-backend
```

### 2. Instalar dependencias + configurar git hooks
```bash
make setup
# O manualmente:
# npm install
# npx husky install
```

### 3. Abrir en VSCode
```bash
code .
```

### 4. ¡Listo para desarrollar!

---

## 📝 Desarrollo Local

### Estructura de proyecto
```
apps-backend/
├── src/              # Código fuente
├── tests/            # Tests unitarios
├── .github/          # GitHub Actions workflows
├── .vscode/          # Configuración VSCode (auto-installed)
├── .editorconfig     # Estilos universales (auto-installed)
├── .prettierrc        # Prettier config (auto-installed)
├── jest.config.js    # Jest config (auto-installed)
├── Makefile          # Dev commands (auto-installed)
├── package.json      # Dependencias
└── .husky/           # Git hooks
```

### Comandos desarrollo (Makefile)

```bash
# Ver todos los comandos disponibles
make help

# Setup + instalación
make setup              # Setup inicial completo
make install            # Solo instalar dependencias

# Desarrollo
make dev                # Ejecutar en watch mode
make lint               # Verificar linting
make lint-fix           # Arreglar issues de linting automáticamente
make format             # Formatear código con Prettier
make test               # Ejecutar tests con coverage
make test-watch         # Tests en watch mode
make build              # Build para producción

# Limpieza
make clean              # Limpiar node_modules y cache
```

### Ejemplos de flujo

#### Opción 1: Desarrollar localmente
```bash
# 1. Crear rama de feature
git checkout -b feature/my-feature

# 2. Hacer cambios en src/
# VSCode auto-formatea al guardar (Prettier)

# 3. Hacer commit
git add .
git commit -m "feat: Add new feature"
# Pre-commit hooks corren automáticamente:
# - ESLint (linting)
# - Prettier (formatting)
# - Secret scanning
# - Commit message validation

# 4. Push a origin
git push origin feature/my-feature

# 5. Crear PR en GitHub
# Ve a: https://github.com/ATD-S-L/apps-backend/pulls

# 6. CI/CD se activa automáticamente:
# - Tests
# - Linting
# - Coverage check (>80%)
# - Build
# - Auto-release en main si PR se mergea
```

#### Opción 2: Crear issue para que agente implemente
```bash
# 1. Ve a: https://github.com/ATD-S-L/apps-backend/issues/new
# 2. Selecciona template: "Agent Task Implementation"
# 3. Describe la feature
# 4. Agrega label: "backend"
# 5. Submit

# El agente:
# - Implementa código + tests
# - Crea PR automático
# - CI/CD valida
# - Auto-merge si pasa
# - Release automático

# Tú revisa PR si lo deseas
```

---

## 🔍 Pre-commit Hooks

Configurados automáticamente con `make setup`:

1. **ESLint** - Detecta errores de sintaxis
2. **Prettier** - Formatea código
3. **Secret scanning** - Evita credentials en commits
4. **Commitlint** - Valida mensaje de commit (conventional commits)

Si un hook falla:
```bash
# Ver error
# Arreglarlo
# Reintentar commit
```

Para bypass (si urgente):
```bash
git commit --no-verify
```

---

## 🧪 Testing

```bash
# Ejecutar todos los tests
make test

# Watch mode (auto-rerun en cambios)
make test-watch

# Coverage report
npm run test -- --coverage

# Debug specific test
npm test -- --testNamePattern="my test"
```

Cobertura mínima requerida: **80%** (se chequea en CI/CD)

---

## 🎨 Código Style

Configurado automáticamente por:

- **ESLint** - Linting (detecta errores)
- **Prettier** - Formatting (espacios, comillas, etc)
- **.editorconfig** - Estilos universales

En VSCode:
- Auto-format al guardar ✅
- Auto-fix ESLint issues ✅
- Prettier integration ✅

---

## 🚨 Troubleshooting

### Pre-commit hook falla
```bash
# Ver error exacto
git status

# Arreglarlo automáticamente
make lint-fix
make format

# Reintentar commit
git add .
git commit -m "feat: ..."
```

### Tests fallan
```bash
# Ver qué falla
make test

# Debug mode
npm test -- --detectOpenHandles --verbose

# En VSCode: Jest extension + debug
```

### ESLint complaints
```bash
# Ver issues
make lint

# Arreglar automáticamente
make lint-fix
```

### Node modules issue
```bash
# Limpiar y reinstalar
make clean
make install
```

---

## 📚 Documentación

- **ARCHITECTURE.md** - Visión general del proyecto
- **DEVELOPER_SETUP.md** - Guía completa de setup
- **CONTRIBUTING.md** - Convenciones de código
- **AGENTS_TEAM_ARCHITECTURE.md** - Cómo funcionan los agentes

---

## 🔗 Enlaces útiles

- [Repository](https://github.com/ATD-S-L/apps-backend)
- [Issues](https://github.com/ATD-S-L/apps-backend/issues)
- [Actions](https://github.com/ATD-S-L/apps-backend/actions)
- [Pull Requests](https://github.com/ATD-S-L/apps-backend/pulls)

---

## ⚙️ Extensiones recomendadas VSCode

Se sugieren al abrir VSCode:

- **Prettier** - Code formatter
- **ESLint** - Linting
- **Jest** - Testing
- **REST Client** - API testing
- **GitLens** - Git integration

O instalar manualmente:
```bash
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension orta.vscode-jest
```

---

**¿Preguntas?** Chequea CONTRIBUTING.md o abre una issue. 🚀
