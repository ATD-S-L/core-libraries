# ADR-001: Multi-Repository Strategy vs Monorepo

**Date:** 2026-11-12  
**Status:** Accepted  
**Authors:** ATD-S-L Architecture Team

## Context

ATD-S-L encompasses multiple distinct domains:
- Backend services (API, business logic)
- Frontend applications (Web UI)
- Firmware/embedded systems (Hardware integration)
- Shared libraries (Common utilities)
- DevOps/infrastructure (Deployment)

The team needed to decide between:
1. **Monorepo** - Single repository with all code
2. **Multi-repo** - Separate repositories for each domain

### Monorepo Considerations (Rejected)
- **Pros**: Unified versioning, atomic refactoring, easier dependency management
- **Cons**: Slower CI/CD for unrelated changes, scaling issues, coordination overhead

### Multi-Repo Considerations (Accepted)
- **Pros**: Independent teams, technology freedom, clear boundaries, scalable builds
- **Cons**: Cross-repo coordination, version management complexity

## Decision

**We choose a MULTI-REPOSITORY strategy** with:

1. **Central documentation repository** (`core-libraries`)
   - Architecture decisions (ADRs)
   - Shared configurations and templates
   - Developer setup guides
   - CI/CD workflow templates

2. **Independent domain repositories**
   - `backend-service`: Business logic and APIs
   - `frontend-app`: User-facing applications
   - `firmware-embedded`: Hardware/IoT integration
   - `shared-libraries`: Reusable code
   - `infrastructure`: Deployment and ops

3. **Unified developer experience**
   - Common pre-commit hooks
   - Shared linting/formatting rules
   - Consistent commit message format
   - Centralized documentation

## Consequences

### Positive
- ✅ **Autonomy**: Teams can work independently, choose tech stacks, deploy on own schedule
- ✅ **Scalability**: Each repo scales based on its needs (size, test suite, build time)
- ✅ **Clear Ownership**: CODEOWNERS file in each repo clarifies responsibility
- ✅ **Technology Diversity**: Backend can use Python, frontend React, firmware Rust, etc.
- ✅ **Reduced Build Impact**: Changes don't trigger unnecessary builds in unrelated domains

### Challenges & Mitigations
| Challenge | Mitigation |
|-----------|-----------|
| Cross-repo refactoring | Documented process in CONTRIBUTING.md; semantic versioning |
| Version management | Semantic versioning with clear major.minor.patch rules |
| Dependency coordination | Shared library versioning; pin minor versions in dependent repos |
| Duplicate configurations | Shared config repository for templates; pre-commit hooks |
| Testing across boundaries | Integration test suite in separate repo |

## Alternatives Considered

### 1. Monorepo (e.g., Nx, Turborepo)
- **Rejected because**: Overkill for current team size; CI/CD overhead when only one service changes
- **Reconsider if**: Team grows to 50+, frequent cross-repo refactoring needed

### 2. Hybrid Approach (Monorepo + Multiple Repos)
- **Rejected because**: Adds complexity without clear benefit; confusing to developers

### 3. Single Repo (Everything)
- **Rejected because**: Violates separation of concerns; unmanageable as project grows

## Implementation Timeline

- **Phase 1 (Week 1)**: Set up `core-libraries` with templates and guidelines
- **Phase 2 (Week 2)**: Create individual repos with consistent structure
- **Phase 3 (Week 3)**: Establish inter-repo integration testing
- **Phase 4 (Ongoing)**: Monitor and adjust based on team feedback

## Related ADRs

- ADR-002: CI/CD Approach (GitHub Actions)
- ADR-003: Pre-commit & Quality Gates
- ADR-004: Semantic Versioning Strategy
- ADR-005: Deployment Approach

## References

- [Monorepo vs Multi-repo Tradeoffs](https://monorepo.tools/)
- [Semantic Versioning](https://semver.org/)
- [GitHub Code Ownership](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
