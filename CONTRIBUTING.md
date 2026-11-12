# Contributing to ATD-S-L

Thank you for your interest in contributing to ATD-S-L! This document provides guidelines for contributing to any repository in the organization.

> 📖 For complete developer setup, see [SETUP_GUIDE.md](./SETUP_GUIDE.md)  
> 📐 For architectural context, see [ARCHITECTURE.md](./ARCHITECTURE.md)

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Before You Start](#before-you-start)
3. [Development Workflow](#development-workflow)
4. [Code Style & Conventions](#code-style--conventions)
5. [Testing Requirements](#testing-requirements)
6. [Commit Messages](#commit-messages)
7. [Pull Request Process](#pull-request-process)
8. [Getting Help](#getting-help)

---

## Code of Conduct

We are committed to creating a welcoming, inclusive, and respectful community.

**Expected Behavior:**
- Be respectful and constructive
- Welcome people of all backgrounds
- Focus on what's best for the community
- Be patient and understanding

**Unacceptable Behavior:**
- Harassment or discrimination
- Personal attacks
- Unwelcome sexual advances
- Deliberate disruption

If you witness unacceptable behavior, please report it to the maintainers.

---

## Before You Start

### 1. Understand the Architecture
Before contributing, familiarize yourself with:
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System overview & structure
- [TECHNOLOGY_MATRIX.md](./TECHNOLOGY_MATRIX.md) - Tech stack decisions
- [ADR/](./ADR/) - Architecture decision records relevant to your change
- Repository-specific README.md

### 2. Development Setup
Follow [SETUP_GUIDE.md](./SETUP_GUIDE.md) to:
- Install required tools
- Clone the repository
- Set up pre-commit hooks
- Configure environment variables

### 3. Understand Decision Records
Architecture decisions are documented in [ADR/](./ADR/):
- **ADR-001**: Multi-repository strategy
- **ADR-002**: CI/CD approach
- **ADR-003**: Pre-commit & quality gates
- **ADR-004**: Semantic versioning
- **ADR-005**: Deployment approach

---

## Development Workflow

### Step 1: Create Feature Branch

```bash
git fetch origin
git checkout -b feature/description  # Feature
# OR: fix/description                # Bug fix
# OR: docs/description               # Documentation
```

Branch naming convention:
| Type | Example | Use For |
|------|---------|---------|
| `feature/*` | `feature/user-auth` | New features |
| `fix/*` | `fix/login-bug` | Bug fixes |
| `docs/*` | `docs/api-guide` | Documentation |
| `refactor/*` | `refactor/db-layer` | Code improvements |
| `chore/*` | `chore/deps` | Dependencies, builds |

### Step 2: Make Changes

Follow [Code Style & Conventions](#code-style--conventions) below.

Write clear, focused commits (see [Commit Messages](#commit-messages)).

### Step 3: Run Pre-Commit Checks

```bash
# Pre-commit hooks run automatically on git commit
# If they fail, fix issues and retry:
git add .
git commit -m "feat: your feature"

# Or run manually:
pre-commit run --all-files
```

Pre-commit checks include:
- Code formatting (Prettier, Black, etc.)
- Linting (ESLint, Ruff, Clippy, etc.)
- Secret detection (TruffleHog)
- Type checking (where applicable)

### Step 4: Run Full Test Suite

```bash
npm test              # Unit tests
npm run test:int      # Integration tests
npm run test:e2e      # End-to-end tests
npm run test:cov      # With coverage report
```

Requirements:
- All tests must pass
- Coverage must be >80% for new code
- No debugging code (console.log, debugger, etc.)

### Step 5: Push & Create Pull Request

```bash
git push origin feature/description

# Create PR via web or CLI
gh pr create --title "feat: your feature" \
             --body "Description of changes"
```

---

## Code Style & Conventions

### Language-Specific Guides

**JavaScript/TypeScript:**
- Use `prettier` for formatting
- Use `eslint` for linting
- Use `typescript` for type safety
- File naming: kebab-case for files, camelCase for exports

**Python:**
- Follow PEP 8 (enforced by Black & Ruff)
- Use type hints (PEP 484)
- File naming: snake_case

**Rust:**
- Follow Rust conventions (rustfmt)
- Use clippy for linting
- Prefer idiomatic Rust

**Go:**
- Follow gofmt (automatic)
- Use golangci-lint
- Follow effective Go

### General Principles

1. **Readability First**
   - Use clear, descriptive names
   - Avoid nested complexity
   - Keep functions focused

2. **Comments**
   - Comment the "why", not the "what"
   - Keep comments accurate and up-to-date
   - Remove debugging comments before commit

3. **Consistency**
   - Follow existing patterns in the codebase
   - Maintain consistent formatting
   - Use standard libraries when available

4. **Documentation**
   - Document public APIs
   - Add JSDoc/docstrings
   - Include usage examples

---

## Testing Requirements

### Test Types

**Unit Tests** (>80% coverage target):
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a new user with valid data', () => {
      // Arrange, Act, Assert pattern
    });

    it('should throw error with invalid email', () => {
      // Test edge case
    });
  });
});
```

**Integration Tests:**
- Test multiple components together
- Test database interactions
- Test API endpoints

**End-to-End Tests:**
- Test complete user workflows
- Test from UI to database
- Test critical paths

### Test File Naming

```
src/utils/helpers.test.ts         # Unit test
tests/integration/api.test.ts      # Integration
tests/e2e/auth.flow.test.ts        # E2E
```

### Running Tests

```bash
npm test                  # All tests
npm test -- --watch      # Watch mode (TDD)
npm test -- --coverage   # Coverage report
```

---

## Commit Messages

Follow **Conventional Commits** format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting (no code change)
- `refactor`: Code restructuring
- `test`: Test additions
- `chore`: Dependencies, build tools

### Subject
- Imperative mood ("add" not "adds" or "added")
- Lowercase first letter
- No period at end
- Max 50 characters

### Body (Optional)
- Explain "what" and "why", not "how"
- Wrap at 72 characters
- Separate from subject with blank line

### Footer (Optional)
- Reference issues: `Closes #123`
- Breaking changes: `BREAKING CHANGE: description`

### Examples

```bash
git commit -m "feat: add user authentication module"

git commit -m "fix: resolve database connection timeout
              
The connection pool was not being recycled properly.
This increases the pool recycle interval from 1h to 30min.

Fixes #456"

git commit -m "docs: update API reference for v2.0

BREAKING CHANGE: GET /api/users endpoint removed"
```

---

## Pull Request Process

### Before Submitting

- [ ] All tests pass locally (`npm test`)
- [ ] Linting passes (`npm run lint`)
- [ ] Type checking passes (`npm run type-check`)
- [ ] Coverage meets threshold (>80%)
- [ ] No debugging code left (console.log, etc.)
- [ ] Updated relevant documentation
- [ ] Commit messages follow conventions

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issues
Closes #123

## Testing
- [ ] Unit tests
- [ ] Integration tests
- [ ] E2E tests

## Documentation
- [ ] Updated README
- [ ] Updated API docs
- [ ] Added code comments
```

### Code Review

**Reviewers will check:**
- ✅ Code follows conventions
- ✅ Tests cover new functionality
- ✅ No security vulnerabilities
- ✅ Performance is acceptable
- ✅ Documentation is complete

**Address feedback:**
```bash
# Make changes
git add .
git commit -m "refactor: address review feedback"
git push origin feature/description

# Don't force-push during review
```

### Merge & Cleanup

Once approved:
```bash
# Merge via GitHub (squash commits recommended)
# OR via CLI:
gh pr merge <number> --squash

# Delete local branch
git checkout main
git pull origin main
git branch -d feature/description
```

---

## Submitting Issues

When creating an issue:

1. **Use the Template**: Fill out the issue template completely
2. **Search First**: Check for existing issues
3. **Be Specific**: Include:
   - Clear description
   - Reproduction steps (for bugs)
   - Expected vs actual behavior
   - Environment details

4. **Add Labels**: bug, feature, documentation, etc.
5. **Link Related**: Reference other issues/PRs if relevant

---

## Getting Help

**Questions about contributing?**
1. Read relevant documentation (ARCHITECTURE.md, etc.)
2. Check GitHub Discussions
3. Open a GitHub Issue
4. Reach out to team leads

**Stuck on implementation?**
1. Check similar examples in the codebase
2. Review tests for usage patterns
3. Ask in GitHub Discussions
4. Reach out for pair programming

**Found a bug in documentation?**
1. Create an issue with `docs` label
2. Submit a PR with corrections
3. Be specific about the problem

---

## Additional Resources

- [SETUP_GUIDE.md](./SETUP_GUIDE.md) - Development environment setup
- [ARCHITECTURE.md](./ARCHITECTURE.md) - System design & decisions
- [TECHNOLOGY_MATRIX.md](./TECHNOLOGY_MATRIX.md) - Tech stack info
- [ADR/](./ADR/) - Architecture Decision Records
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)

---

## Code Review Expectations

### Reviewers
- Provide constructive feedback
- Suggest improvements, not demands
- Acknowledge good work
- Be respectful of author's time

### Authors
- Welcome feedback gracefully
- Discuss disagreements professionally
- Provide context for decisions
- Keep conversations respectful

---

Thank you for contributing to ATD-S-L! 🙏

**Questions?** Open a discussion or issue in this repository.

---

*Last Updated: 2026-11-12*  
*Maintained By: ATD-S-L Community*
