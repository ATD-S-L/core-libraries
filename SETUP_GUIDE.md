# ATD-S-L Developer Setup Guide

**Version:** 1.0  
**Last Updated:** 2026-11-12  
**Status:** Complete

Welcome to ATD-S-L! This guide will help you set up your development environment and get started contributing.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Repository Setup](#repository-setup)
3. [Environment Configuration](#environment-configuration)
4. [Local Development](#local-development)
5. [Running Tests](#running-tests)
6. [Code Contribution Workflow](#code-contribution-workflow)
7. [Troubleshooting](#troubleshooting)
8. [Additional Resources](#additional-resources)

---

## Prerequisites

### Required Tools

- **Git** (v2.30+)
  ```bash
  git --version  # Check installation
  ```

- **Node.js & npm** (for JavaScript/TypeScript projects)
  ```bash
  # Install from https://nodejs.org/
  node --version  # Should be 18.x or higher
  npm --version   # Should be 9.x or higher
  ```

- **Python** (for Python projects - optional)
  ```bash
  # Install from https://www.python.org/
  python --version  # Should be 3.11+
  pip --version
  ```

- **Docker** (for containerized development)
  ```bash
  # Install from https://www.docker.com/
  docker --version
  ```

- **Pre-commit** (for code quality checks)
  ```bash
  pip install pre-commit  # Install globally
  pre-commit --version
  ```

- **GitHub CLI** (for repository management - optional but recommended)
  ```bash
  # Install from https://cli.github.com/
  gh --version
  ```

### Account Setup

- GitHub account with access to ATD-S-L repositories
- Git configured locally:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your.email@example.com"
  ```

---

## Repository Setup

### 1. Choose Your Focus Area

Select the repository you want to work on:

```
┌─ core-libraries          (Documentation & shared configs)
├─ backend-service         (API & business logic)
├─ frontend-app            (Web UI)
├─ firmware-embedded       (IoT/hardware)
├─ shared-libraries        (Common utilities)
└─ infrastructure          (Deployment)
```

### 2. Clone the Repository

**Using HTTPS (Recommended for most):**
```bash
cd ~/projects/  # Or your preferred directory
git clone https://github.com/ATD-S-L/core-libraries.git
cd core-libraries
```

**Using SSH (if SSH key configured):**
```bash
git clone git@github.com:ATD-S-L/core-libraries.git
cd core-libraries
```

### 3. Install Dependencies

**For Node.js projects:**
```bash
npm install
```

**For Python projects:**
```bash
python -m venv venv          # Create virtual environment
source venv/bin/activate     # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

**For Rust projects:**
```bash
# Install Rust: https://rustup.rs/
rustup update
cargo fetch  # Download dependencies
```

### 4. Set Up Pre-Commit Hooks

```bash
# Install pre-commit hook
pre-commit install

# Run against all files to ensure setup works
pre-commit run --all-files
```

The pre-commit hook will run before each commit and catch:
- Code formatting issues
- Linting errors
- Secret leaks
- Large files

**Skip hooks (only in emergency):**
```bash
git commit --no-verify  # Not recommended!
```

---

## Environment Configuration

### 1. Configure Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env  # If .env.example exists
```

Edit `.env` with local development settings:

```env
# Example for backend service
NODE_ENV=development
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
REDIS_URL=redis://localhost:6379
LOG_LEVEL=debug
```

**⚠️ IMPORTANT:** Never commit `.env` file; it's already in `.gitignore`

### 2. Database Setup

**For local PostgreSQL:**
```bash
# Using Docker Compose (recommended)
docker-compose up -d postgres redis

# Or install locally (macOS)
brew install postgresql redis
brew services start postgresql
```

**Initialize database:**
```bash
npm run db:migrate  # Or language-specific equivalent
npm run db:seed     # Optional: load sample data
```

### 3. API Keys & Secrets

Request sensitive credentials from your team lead:
- Database connection strings
- API keys (external services)
- OAuth credentials
- Signing keys

Store these in:
- `.env` file (local development only)
- GitHub Secrets (for CI/CD)
- Team password manager (for sharing)

---

## Local Development

### Running the Application

**Node.js/TypeScript:**
```bash
npm run dev      # Start development server (hot reload)
npm start        # Start production build
npm run build    # Compile TypeScript
```

**Python:**
```bash
python manage.py runserver  # Django
uvicorn main:app --reload   # FastAPI
```

**Rust:**
```bash
cargo run       # Build and run
cargo watch     # Watch for changes and rebuild
```

**Docker:**
```bash
docker-compose up          # Start all services
docker-compose up -d       # Detached mode
docker-compose down        # Stop services
docker-compose logs -f     # View logs
```

### Accessing the Application

After starting the development server, access it at:
- **Backend API**: http://localhost:3000 (or configured port)
- **Frontend**: http://localhost:5173 (Vite default)
- **Database UI**: http://localhost:5432 (or pgAdmin at :8080)

### Code Editor Setup

**Recommended: Visual Studio Code**

Extensions to install:
```json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-python.python",
    "rust-lang.rust-analyzer",
    "redhat.vscode-yaml"
  ]
}
```

Settings for this project (`.vscode/settings.json`):
```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.python",
    "editor.formatOnSave": true
  }
}
```

---

## Running Tests

### Test Types

**Unit Tests** (Fast, test single functions):
```bash
npm test              # Run all unit tests
npm test -- --watch  # Watch mode for TDD
npm test -- --coverage  # Coverage report
```

**Integration Tests** (Slower, test components together):
```bash
npm run test:integration
```

**End-to-End Tests** (Slowest, test full workflows):
```bash
npm run test:e2e
```

### Test Coverage

Aim for >80% code coverage:
```bash
npm test -- --coverage
```

Check coverage report:
```
# Terminal output shows line-by-line coverage
# HTML report at: coverage/lcov-report/index.html
```

### Writing Tests

Follow the naming convention:
- Unit: `src/utils/helpers.test.ts`
- Integration: `tests/integration/api.test.ts`
- E2E: `tests/e2e/auth.test.ts`

Example:
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a new user with valid data', async () => {
      const user = await userService.createUser({
        name: 'John Doe',
        email: 'john@example.com',
      });
      expect(user.id).toBeDefined();
      expect(user.email).toBe('john@example.com');
    });
  });
});
```

---

## Code Contribution Workflow

### 1. Create a Feature Branch

```bash
git fetch origin              # Get latest changes
git checkout -b feature/my-feature  # Create branch from main
# OR: fix/bug-description
# OR: docs/documentation-update
```

Branch naming:
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation
- `refactor/description` - Code improvements
- `chore/description` - Dependencies, build tools

### 2. Make Changes & Commit

Write code following [ARCHITECTURE.md conventions](./ARCHITECTURE.md#code-conventions).

Commit messages follow Conventional Commits:
```bash
git add .
git commit -m "feat: add user authentication module"
# feat: new feature
# fix: bug fix
# docs: documentation
# style: formatting
# refactor: code restructuring
# test: test additions
# chore: dependency updates
```

### 3. Pre-Commit Checks

Pre-commit hooks run automatically:
- ✅ Code formatting (prettier)
- ✅ Linting (eslint, ruff)
- ✅ Type checking
- ✅ Secret scanning

If checks fail, fix issues and try commit again:
```bash
git add .
git commit -m "feat: add user authentication module"
```

### 4. Push and Create Pull Request

```bash
git push origin feature/my-feature  # Push to remote

# Create PR via GitHub web UI or CLI
gh pr create --title "feat: add user authentication" \
             --body "Description of changes"
```

### 5. Code Review Process

**Checklist before submitting:**
- [ ] Tests pass locally (`npm test`)
- [ ] No linting errors (`npm run lint`)
- [ ] Type checking passes (`npm run type-check`)
- [ ] Coverage meets threshold (>80%)
- [ ] Commit messages follow conventions
- [ ] No debugging code left (console.log, debugger, etc.)

**What reviewers look for:**
- ✅ Code follows conventions
- ✅ Tests cover new functionality
- ✅ No security vulnerabilities
- ✅ Performance is acceptable
- ✅ Documentation is complete

**Addressing feedback:**
```bash
# Make requested changes
git add .
git commit -m "refactor: address code review feedback"
git push origin feature/my-feature

# Push again (don't force-push before review complete)
```

### 6. Merge to Main

**After approval:**
- All tests must pass (CI/CD checks)
- At least 1 approval required
- No conflicts with main branch

```bash
# Merge via GitHub web UI (squash commits)
# OR via CLI:
gh pr merge <number> --squash  # Recommended
```

**After merge:**
```bash
git checkout main
git pull origin main
git branch -d feature/my-feature  # Delete local branch
git push origin --delete feature/my-feature  # Delete remote
```

---

## Troubleshooting

### Common Issues

#### Issue: "pre-commit: command not found"
**Solution:**
```bash
pip install pre-commit --upgrade
pre-commit install
```

#### Issue: "Port 3000 already in use"
**Solution:**
```bash
# Find process using port
lsof -i :3000  # macOS/Linux
netstat -ano | findstr :3000  # Windows

# Kill process or use different port
PORT=3001 npm run dev
```

#### Issue: "Database connection refused"
**Solution:**
```bash
# Start database services
docker-compose up -d postgres redis

# Check connection string in .env
# Verify database is running: docker ps
```

#### Issue: "npm install fails"
**Solution:**
```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

#### Issue: "Git merge conflicts"
**Solution:**
```bash
# Resolve conflicts in editor
# Mark files as resolved:
git add <resolved-file>

# Complete merge:
git commit -m "chore: resolve merge conflicts"
```

### Getting Help

1. **Check documentation**
   - README.md in your repository
   - ARCHITECTURE.md in core-libraries
   - Code comments for complex logic

2. **Search GitHub Issues**
   - Similar issues may already be solved
   - Add your case if different

3. **Create an Issue**
   - Use issue templates provided
   - Include error messages, steps to reproduce
   - Share environment details

4. **Ask in Discussions**
   - For general questions
   - Non-urgent help requests

5. **Reach Out to Team**
   - For blocked issues
   - Urgent help needed

---

## Additional Resources

### Documentation
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System design & decisions
- [ADR/](./ADR/) - Architecture Decision Records
- [TECHNOLOGY_MATRIX.md](./TECHNOLOGY_MATRIX.md) - Tech stack decisions
- Individual README.md in each repository

### Tools & Services
- [GitHub](https://github.com/ATD-S-L)
- [GitHub Discussions](https://github.com/ATD-S-L/core-libraries/discussions)
- [GitHub Issues](https://github.com/ATD-S-L/core-libraries/issues)

### Learning Resources
- [Git Guide](https://github.com/git-tips/tips)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Python Best Practices](https://peps.python.org/pep-0008/)
- [Conventional Commits](https://www.conventionalcommits.org/)

### Team Contacts
- **Architecture Lead**: See CODEOWNERS
- **Backend**: See backend-service CODEOWNERS
- **Frontend**: See frontend-app CODEOWNERS
- **DevOps**: See infrastructure CODEOWNERS

---

## Next Steps

1. ✅ Complete this setup guide
2. ✅ Run `npm test` to verify setup
3. ✅ Read [ARCHITECTURE.md](./ARCHITECTURE.md)
4. ✅ Create your first feature branch
5. ✅ Submit your first pull request

---

**Questions?**
- Create a GitHub Discussion
- Reach out to your team lead
- Check existing documentation

**Happy coding!** 🚀

---

*Last Updated: 2026-11-12*  
*Maintained By: ATD-S-L Development Team*
