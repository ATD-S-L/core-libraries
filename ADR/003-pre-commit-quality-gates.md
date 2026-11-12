# ADR-003: Pre-Commit and Quality Gates

**Date:** 2026-11-12  
**Status:** Accepted  
**Authors:** ATD-S-L Architecture Team

## Context

To maintain code quality across all repositories, we need:
- Consistent code formatting
- Linting and static analysis
- Security checks before commit
- Type checking for relevant languages
- Fast feedback loop (local, not just CI)

## Decision

**We implement a standardized pre-commit framework** with shared hooks across all repositories.

### Tool Selection

| Tool | Purpose | Status |
|------|---------|--------|
| `pre-commit` | Framework for git hooks | ✅ Required |
| `prettier` | Code formatting (JS/TS) | ✅ Required |
| `eslint` | JavaScript linting | ✅ Required |
| `ruff` | Python linting & formatting | ✅ For Python repos |
| `clippy` | Rust linting | ✅ For Rust repos |
| `truffleHog` | Secret detection | ✅ Required |
| `detect-secrets` | Secret prevention | ✅ Required |

### Implementation

1. **Shared Configuration** (in `core-libraries`)
   - `.pre-commit-config.yaml` - Base template
   - Individual repos extend this template

2. **Installation**
   ```bash
   # One-time setup
   pip install pre-commit
   pre-commit install
   
   # Pre-commit runs on every git commit
   ```

3. **Bypass (Only in Emergency)**
   ```bash
   git commit --no-verify  # Use sparingly!
   ```

## Consequences

### Positive
- ✅ **Consistent Code**: All code follows same standards
- ✅ **Faster CI**: Issues caught locally before push
- ✅ **Developer Experience**: Quick feedback loop
- ✅ **Security**: Prevents accidental secret commits
- ✅ **No More Formatting Debates**: Rules are codified

### Challenges & Mitigations
| Challenge | Mitigation |
|-----------|-----------|
| Initial setup overhead | Document in SETUP_GUIDE.md; automate where possible |
| Slow commits (many hooks) | Run only changed files; parallelize where possible |
| False positives | Configure exclusions in .pre-commit-config.yaml |
| Team resistance | Show benefits with metrics; gradual rollout |

## Quality Gate Levels

### Level 1: Local (Pre-Commit)
- Formatting
- Linting
- Basic type checking
- Secret detection

### Level 2: CI/CD (GitHub Actions)
- Full test suite
- Coverage analysis
- Security scanning
- Integration tests

### Level 3: Code Review (GitHub)
- Architecture review
- Logic correctness
- Documentation completeness

## Exclusions & Overrides

Teams can exclude certain files/paths in `.pre-commit-config.yaml`:

```yaml
exclude: |
  (?x)^(
    migrations/|
    generated/|
    node_modules/
  )
```

## Related ADRs

- ADR-001: Multi-Repository Strategy
- ADR-002: CI/CD Approach
- ADR-004: Semantic Versioning Strategy

## References

- [Pre-commit Framework](https://pre-commit.com/)
- [Prettier Configuration](https://prettier.io/docs/en/configuration.html)
- [ESLint Configuration](https://eslint.org/docs/user-guide/configuring/)
- [TruffleHog Security](https://github.com/trufflesecurity/trufflehog)
