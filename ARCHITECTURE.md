# ATD-S-L Architecture Documentation

**Version:** 1.0  
**Last Updated:** 2026-11-12  
**Status:** Active

## Table of Contents
1. [Vision](#vision)
2. [Multi-Repo Strategy](#multi-repo-strategy)
3. [Repository Structure](#repository-structure)
4. [Technology Decisions](#technology-decisions)
5. [Communication Patterns](#communication-patterns)
6. [Code Conventions](#code-conventions)
7. [Contribution Guidelines](#contribution-guidelines)
8. [Decision Framework](#decision-framework)

---

## Vision

ATD-S-L is a comprehensive multi-repository ecosystem designed to support:
- **Backend Services**: Core business logic and APIs
- **Frontend Applications**: User-facing interfaces
- **Firmware/Embedded**: IoT and hardware integration
- **Shared Libraries**: Common utilities and cross-cutting concerns
- **DevOps/Infrastructure**: Deployment and operations

The architecture prioritizes **clear separation of concerns**, **independent scalability**, and **unified developer experience**.

---

## Multi-Repo Strategy

### Why Multi-Repo?

We have chosen a **multi-repository strategy** (as opposed to a monorepo) to achieve:

| Benefit | Rationale |
|---------|-----------|
| **Independent Scaling** | Each component can scale based on its own requirements |
| **Autonomous Teams** | Teams own their repository and release cycle |
| **Clear Boundaries** | Explicit contracts prevent tight coupling |
| **Technology Diversity** | Each repo can use optimal tech stack for its domain |
| **Reduced Build Impact** | Changes don't trigger unnecessary rebuilds across teams |

### Trade-offs Accepted

- **Coordination overhead** → Mitigated by clear ADRs and conventions
- **Version management** → Addressed through semantic versioning
- **Shared testing** → Solved via integration test repository
- **Documentation maintenance** → Centralized in core-libraries

---

## Repository Structure

### Core Repositories

```
ATD-S-L/
├── core-libraries/          (THIS REPO - Central documentation & base setup)
│   ├── ARCHITECTURE.md
│   ├── ADR/                 (Architecture Decision Records)
│   ├── TECHNOLOGY_MATRIX.md
│   ├── SETUP_GUIDE.md
│   ├── .github/
│   │   ├── workflows/       (Shared CI/CD templates)
│   │   └── ISSUE_TEMPLATE/
│   └── shared-configs/      (eslint, prettier, etc.)
│
├── backend-service/         (TBD: See TECHNOLOGY_MATRIX.md)
│   ├── src/
│   ├── tests/
│   ├── docker/
│   └── .github/workflows/
│
├── frontend-app/            (TBD: See TECHNOLOGY_MATRIX.md)
│   ├── src/
│   ├── tests/
│   ├── public/
│   └── .github/workflows/
│
├── firmware-embedded/       (TBD: See TECHNOLOGY_MATRIX.md)
│   ├── firmware/
│   ├── hardware-configs/
│   └── .github/workflows/
│
├── shared-libraries/        (TBD: See TECHNOLOGY_MATRIX.md)
│   ├── utils/
│   ├── models/
│   ├── validators/
│   └── .github/workflows/
│
└── infrastructure/          (Deployment templates & ops)
    ├── docker-compose.yml
    ├── k8s/
    └── .github/workflows/
```

---

## Technology Decisions

All technology stack decisions are documented in **[TECHNOLOGY_MATRIX.md](./TECHNOLOGY_MATRIX.md)**.

### Summary (To Be Finalized)

| Layer | Decision | Status | Notes |
|-------|----------|--------|-------|
| Backend | *Pending* | ⏳ | See TECHNOLOGY_MATRIX.md ADR-002 |
| Frontend | *Pending* | ⏳ | See TECHNOLOGY_MATRIX.md ADR-003 |
| Firmware | *Pending* | ⏳ | See TECHNOLOGY_MATRIX.md ADR-004 |
| Shared Libs | *Pending* | ⏳ | See TECHNOLOGY_MATRIX.md ADR-005 |
| DevOps | Docker, GitHub Actions | ✅ | Base established in core-libraries |

---

## Communication Patterns

### Inter-Repository Dependencies

```
backend-service
    ↓ (uses)
shared-libraries
    ↑ (provides types/utils)

frontend-app
    ↓ (calls)
backend-service (REST/GraphQL API)

firmware-embedded
    → (independent, may integrate with backend via API)
```

### API Contracts

- **Backend → Frontend**: RESTful or GraphQL (versioned)
- **Backend → Firmware**: REST API with clear versioning
- **All → Shared Libraries**: Semantic versioning (major.minor.patch)

### Cross-Repo Communication

1. **GitHub Discussions**: Feature requests, RFC discussions
2. **Issues**: Bugs and maintenance tracked in respective repos
3. **PRs**: Code reviews reference related work
4. **Release Notes**: Each repo maintains CHANGELOG.md

---

## Code Conventions

### Universal Standards

All repositories follow these standards:

#### 1. **Version Control**
- Branch naming: `feature/description`, `fix/description`, `docs/description`
- Commit messages: Conventional Commits (feat:, fix:, docs:, refactor:, test:, chore:)
- Squash commits on merge to main

#### 2. **Documentation**
- `README.md`: Project overview and setup
- `CONTRIBUTING.md`: How to contribute
- `CHANGELOG.md`: Version history
- Code comments only for "why", not "what"

#### 3. **Testing**
- Unit tests: >80% coverage target
- Integration tests: Critical paths
- End-to-end tests: User workflows
- Test naming: `test.[unit|integration|e2e].ts`

#### 4. **Code Style**
- Use repository-level configurations (`.eslintrc`, `.prettier-config`)
- Pre-commit hooks enabled (see `setup-base` branch)
- CI/CD enforces linting before merge

#### 5. **Security**
- No secrets in code (use environment variables)
- Dependencies scanned (Dependabot enabled)
- Regular security audits (quarterly)

---

## Contribution Guidelines

### Quick Start

1. **Clone and setup** (see [SETUP_GUIDE.md](./SETUP_GUIDE.md))
2. **Branch off `main`** with descriptive name
3. **Make changes** following code conventions
4. **Run tests** locally before pushing
5. **Create PR** with clear description
6. **Address review feedback** respectfully
7. **Merge when approved** (squash commits to main)

### Pull Request Process

```
1. Fork or create feature branch
2. Make commits with clear messages
3. Push and open PR
4. Automated checks run (linting, tests, security)
5. Request code review (at least 1 approval)
6. Address feedback or discuss concerns
7. Merge to main (squash if >1 commit)
8. Delete feature branch
```

### Breaking Changes

- Must follow semantic versioning
- Document in CHANGELOG.md
- Update dependent repos
- Announce in GitHub Discussions

---

## Decision Framework

Architectural decisions are recorded as **Architecture Decision Records (ADRs)** in the [ADR/](./ADR/) directory.

### ADR Structure

```
# ADR-NNN: Title

**Date:** YYYY-MM-DD  
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-XXX

## Context
Why are we making this decision?

## Decision
What have we decided?

## Consequences
What are the implications?

## Alternatives Considered
What else did we evaluate?
```

### Active ADRs

See [ADR/](./ADR/) directory for complete list:

- **ADR-001**: Multi-repo strategy vs monorepo → **Accepted**
- **ADR-002**: CI/CD approach (GitHub Actions) → **Accepted**
- **ADR-003**: Pre-commit & quality gates → **Accepted**
- **ADR-004**: Semantic versioning strategy → **Accepted**
- **ADR-005**: Deployment approach (Docker + GitHub Actions) → **Accepted**

---

## Support & Questions

### Documentation
- Central documentation: This repository
- Repo-specific docs: See individual README.md files
- Setup help: [SETUP_GUIDE.md](./SETUP_GUIDE.md)

### Getting Help
1. Check relevant README.md
2. Search existing GitHub Issues
3. Create new issue or discussion
4. Reach out to team leads

### Keeping This Document Updated

When:
- Making architectural decisions → Create ADR
- Changing code conventions → Update this document
- Adding new repositories → Update repository structure
- Finalizing tech stacks → Update TECHNOLOGY_MATRIX.md

---

**Last Reviewed:** 2026-11-12  
**Next Review:** 2027-02-12 (Quarterly)

*For detailed technology decisions, see [TECHNOLOGY_MATRIX.md](./TECHNOLOGY_MATRIX.md)*  
*For setup instructions, see [SETUP_GUIDE.md](./SETUP_GUIDE.md)*
