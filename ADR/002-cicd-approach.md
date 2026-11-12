# ADR-002: CI/CD Approach

**Date:** 2026-11-12  
**Status:** Accepted  
**Authors:** ATD-S-L Architecture Team

## Context

ATD-S-L requires a CI/CD system that:
- Works across multiple repositories with different tech stacks
- Provides fast feedback on pull requests
- Automates testing, linting, and deployment
- Integrates with GitHub platform
- Scales as the organization grows
- Minimizes operational overhead

## Decision

**We adopt GitHub Actions as our CI/CD platform** with standardized workflow templates.

### Implementation Details

1. **Workflow Templates** (in `core-libraries`)
   - `.github/workflows/lint.yml` - Code quality checks
   - `.github/workflows/test.yml` - Run unit and integration tests
   - `.github/workflows/security.yml` - Security scanning
   - `.github/workflows/deploy.yml` - Deployment workflows

2. **Required Checks on PRs**
   - Linting passes (ESLint, Prettier, etc.)
   - Unit tests pass (>80% coverage)
   - Security scans pass (no vulnerabilities)
   - Code review approvals (minimum 1)

3. **Automatic Deployment**
   - Merge to `main` triggers production deployment
   - Staging environment for QA
   - Rollback capability via GitHub releases

4. **Secrets Management**
   - GitHub Secrets for environment variables
   - No hardcoded credentials
   - Access controlled via CODEOWNERS

## Consequences

### Positive
- ✅ **Native Integration**: Works seamlessly with GitHub PRs and repos
- ✅ **Minimal Setup**: No external services to manage
- ✅ **Matrix Builds**: Test across multiple Node/Python/Go versions
- ✅ **Workflow Reusability**: Teams share common templates
- ✅ **Cost-Effective**: Generous free tier for open source
- ✅ **Security**: Built-in OIDC, artifact signing capabilities

### Challenges & Mitigations
| Challenge | Mitigation |
|-----------|-----------|
| Workflow duplication | Use reusable workflows in core-libraries |
| Complex workflows | Keep workflows simple; use scripts for logic |
| Debugging failures | Local act for testing; verbose logging |

## Alternatives Considered

### 1. GitLab CI
- **Rejected because**: Not GitHub-native; adds operational overhead
- **Good for**: Projects already using GitLab

### 2. Jenkins
- **Rejected because**: Requires self-hosting; too much maintenance burden
- **Good for**: Complex legacy build requirements

### 3. CircleCI/Travis CI
- **Rejected because**: GitHub Actions is more cost-effective and integrated
- **Good for**: Projects needing advanced features

## Implementation Checklist

- [x] Set up core-libraries with workflow templates
- [x] Create lint.yml workflow
- [x] Create test.yml workflow
- [x] Create security.yml workflow
- [ ] Document in SETUP_GUIDE.md
- [ ] Add local testing with act
- [ ] Set up branch protection rules

## Related ADRs

- ADR-001: Multi-Repository Strategy
- ADR-003: Pre-commit & Quality Gates
- ADR-005: Deployment Approach

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Actions Best Practices](https://docs.github.com/en/actions/guides/security-hardening-for-github-actions)
- [Act - Run GitHub Actions Locally](https://github.com/nektos/act)
