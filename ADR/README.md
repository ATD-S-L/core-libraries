# ADR Index

This directory contains all Architecture Decision Records (ADRs) for ATD-S-L.

## What is an ADR?

An Architecture Decision Record is a document that captures an important architectural decision made by a development team, along with its context and consequences.

## Format

Each ADR follows this structure:
- **Title**: Clear, descriptive
- **Date**: When decided
- **Status**: Proposed, Accepted, Deprecated, Superseded
- **Context**: Why are we making this decision?
- **Decision**: What have we decided?
- **Consequences**: What are the implications?
- **Alternatives**: What else did we consider?

## Active ADRs

| ADR | Title | Status | Repo Impact |
|-----|-------|--------|-------------|
| [001](./001-multi-repo-strategy.md) | Multi-Repository Strategy vs Monorepo | Accepted | All repos |
| [002](./002-cicd-approach.md) | CI/CD Approach (GitHub Actions) | Accepted | All repos |
| [003](./003-pre-commit-quality-gates.md) | Pre-Commit & Quality Gates | Accepted | All repos |
| [004](./004-semantic-versioning.md) | Semantic Versioning Strategy | Accepted | All repos |
| [005](./005-deployment-approach.md) | Deployment Approach (Docker + GitHub Actions) | Accepted | All repos |

## Proposed ADRs

None at this time.

## Deprecated/Superseded ADRs

None at this time.

## How to Add an ADR

1. **Identify Need**: Architecture decision needed? Create ADR.
2. **Follow Format**: Use the structure above
3. **Propose**: Create PR with `ADR-NNN-title.md`
4. **Discuss**: Team reviews and provides feedback
5. **Accept**: Merge when consensus reached
6. **Implement**: Update repositories to follow ADR
7. **Link**: Reference in relevant documentation

## Example Workflow

```bash
# Create new ADR
cp ADR/000-template.md ADR/006-my-decision.md

# Edit and propose
git add ADR/006-my-decision.md
git commit -m "docs: ADR-006 - My Decision"
git push origin feature/adr-006

# Create PR for discussion
gh pr create --title "ADR-006: My Decision" --body "See details in ADR"

# After approval, merge and update ARCHITECTURE.md
```

## When to Create an ADR

✅ **Create an ADR for:**
- Technology stack choices
- Architectural patterns
- Cross-repo communication decisions
- CI/CD and deployment strategies
- Versioning and release policies
- Security and compliance standards

❌ **Don't create an ADR for:**
- Small bug fixes
- Minor code style changes
- Local development setup
- Implementation details within a single service

## Reviewing ADRs

When reviewing ADRs, consider:
1. **Clarity**: Is the decision clear and understandable?
2. **Completeness**: Are context and consequences thorough?
3. **Rationale**: Is the decision justified?
4. **Feasibility**: Can this be practically implemented?
5. **Impact**: Who is affected? Is communication needed?

## Questions?

- Check existing ADRs for similar decisions
- Discuss in GitHub Discussions
- Ask in team meetings
- Refer to ARCHITECTURE.md for high-level overview

---

**Last Updated:** 2026-11-12  
**Maintained By:** ATD-S-L Architecture Team
