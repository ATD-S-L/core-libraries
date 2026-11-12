# Core Libraries - ATD-S-L

**Central documentation, configuration, and shared utilities repository for ATD-S-L organization.**

🏗️ **Master Repository** | 📚 **Architecture Hub** | 🛠️ **Shared Tools**

---

## About This Repository

`core-libraries` is the central repository for the ATD-S-L organization, containing:

✅ **Architecture & Decisions** - ADRs, design patterns, organizational decisions  
✅ **Developer Guides** - Setup instructions, contribution guidelines  
✅ **Technology Matrix** - Tech stack selections across all domains  
✅ **Shared Configurations** - Linting, formatting, CI/CD templates  
✅ **Shared Code Libraries** - Common utilities used across repos  

## 📖 Documentation

Start here to understand ATD-S-L:

| Document | Purpose |
|----------|---------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | System design, multi-repo structure, conventions |
| [SETUP_GUIDE.md](./SETUP_GUIDE.md) | Developer onboarding & local development |
| [TECHNOLOGY_MATRIX.md](./TECHNOLOGY_MATRIX.md) | Tech stack decisions for each domain |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | How to contribute to any ATD-S-L repo |
| [ADR/](./ADR/) | Architecture Decision Records (001-005) |

## 🚀 Quick Start

### 1. First Time Setup
```bash
git clone https://github.com/ATD-S-L/core-libraries.git
cd core-libraries
# Read the documentation
cat SETUP_GUIDE.md
```

### 2. Understand Architecture
- Read [ARCHITECTURE.md](./ARCHITECTURE.md) for system overview
- Check [TECHNOLOGY_MATRIX.md](./TECHNOLOGY_MATRIX.md) for tech decisions
- Review [ADR/](./ADR/) for detailed decision records

### 3. Clone Other Repos You Need
```bash
# Backend service
git clone https://github.com/ATD-S-L/backend-service.git

# Frontend app
git clone https://github.com/ATD-S-L/frontend-app.git

# Others as needed...
```

### 4. Start Contributing
- Pick an issue from any ATD-S-L repository
- Follow [CONTRIBUTING.md](./CONTRIBUTING.md)
- Create a pull request

## 📁 Repository Structure

```
core-libraries/
├── ARCHITECTURE.md              ⭐ Start here - System design
├── SETUP_GUIDE.md              ⭐ Developer onboarding
├── TECHNOLOGY_MATRIX.md        ⭐ Tech stack decisions
├── CONTRIBUTING.md              ⭐ Contribution guidelines
├── ADR/                         ⭐ Architecture Decision Records
│   ├── README.md               # ADR guide
│   ├── 001-multi-repo-strategy.md
│   ├── 002-cicd-approach.md
│   ├── 003-pre-commit-quality-gates.md
│   ├── 004-semantic-versioning.md
│   └── 005-deployment-approach.md
├── .github/
│   ├── workflows/              # CI/CD templates (shared across repos)
│   └── ISSUE_TEMPLATE/         # GitHub issue templates
├── src/                        # Implementation & shared libraries
├── tests/                      # Test suite
├── examples/                   # Usage examples
├── docs/                       # API documentation
├── LICENSE                     # MIT License
└── .gitignore

```

## 🏢 ATD-S-L Organization

This repository is part of the ATD-S-L organization. Related repositories:

| Repository | Purpose | Status |
|-----------|---------|--------|
| **core-libraries** | Central documentation & shared configs | ✅ Active |
| **backend-service** | API & business logic | ⏳ TBD |
| **frontend-app** | Web application | ⏳ TBD |
| **firmware-embedded** | IoT & hardware integration | ⏳ TBD |
| **shared-libraries** | Reusable code across repos | ⏳ TBD |
| **infrastructure** | Deployment & DevOps | ⏳ TBD |

*Status: See [TECHNOLOGY_MATRIX.md](./TECHNOLOGY_MATRIX.md) for tech stack selections*

## 🤝 Contributing

We welcome contributions from all team members!

**Before contributing:**
1. Read [ARCHITECTURE.md](./ARCHITECTURE.md) for system overview
2. Review [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines
3. Follow [SETUP_GUIDE.md](./SETUP_GUIDE.md) for environment setup
4. Check [ADR/](./ADR/) for relevant decisions

**Quick workflow:**
```bash
# 1. Create feature branch
git checkout -b feature/your-feature

# 2. Make changes following conventions
# 3. Run tests and linting
npm test && npm run lint

# 4. Commit with conventional messages
git commit -m "feat: add new feature"

# 5. Push and create PR
git push origin feature/your-feature
gh pr create --title "feat: add new feature"
```

For detailed instructions, see [CONTRIBUTING.md](./CONTRIBUTING.md)

## 🔍 Key Decisions

Core architectural decisions for ATD-S-L:

- ✅ **Multi-Repo Strategy** - Independent repos per domain (ADR-001)
- ✅ **GitHub Actions CI/CD** - Standardized automation (ADR-002)
- ✅ **Pre-Commit Hooks** - Quality gates before commit (ADR-003)
- ✅ **Semantic Versioning** - Clear version management (ADR-004)
- ✅ **Docker Deployment** - Containerized, reproducible builds (ADR-005)

See [ADR/](./ADR/) directory for complete details.

## 📚 Resources

- **GitHub**: https://github.com/ATD-S-L
- **Discussions**: https://github.com/ATD-S-L/core-libraries/discussions
- **Issues**: https://github.com/ATD-S-L/core-libraries/issues

## ❓ Getting Help

1. **Documentation** - Check relevant .md files above
2. **Examples** - See `examples/` directory
3. **GitHub Discussions** - Ask community
4. **GitHub Issues** - Report bugs or request features
5. **Team Lead** - For urgent or complex issues

## 📋 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

## 🎯 Next Steps

- [ ] Read [ARCHITECTURE.md](./ARCHITECTURE.md)
- [ ] Follow [SETUP_GUIDE.md](./SETUP_GUIDE.md)
- [ ] Pick a repository to contribute to
- [ ] Create your first pull request

---

**Last Updated:** 2026-11-12  
**Maintained By:** ATD-S-L Architecture Team
