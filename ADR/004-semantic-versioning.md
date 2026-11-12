# ADR-004: Semantic Versioning Strategy

**Date:** 2026-11-12  
**Status:** Accepted  
**Authors:** ATD-S-L Architecture Team

## Context

With multiple independent repositories, clear versioning is essential to:
- Track API compatibility
- Manage dependency updates safely
- Communicate breaking changes
- Coordinate releases across repos
- Establish trust with users

## Decision

**We adopt Semantic Versioning (semver) for all repositories.**

### Version Format

```
MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]

Example: 1.2.3, 1.0.0-alpha, 2.0.0-rc.1
```

### Versioning Rules

| Version | When to Increment | Examples |
|---------|-------------------|----------|
| **MAJOR** | Breaking API changes | 1.0.0 → 2.0.0 |
| **MINOR** | New features (backward compatible) | 1.0.0 → 1.1.0 |
| **PATCH** | Bug fixes only | 1.0.0 → 1.0.1 |

### Breaking vs. Non-Breaking Changes

**MAJOR (Breaking):**
- Removing public API method
- Changing function signature
- Database schema changes (incompatible)
- Endpoint removal or behavior change
- Dependency major version bump

**MINOR (Feature, Non-Breaking):**
- New API endpoint
- New optional parameter
- Deprecating a method (with warning)
- Performance improvements
- Dependency minor version bump

**PATCH (Bug Fix):**
- Bug fixes
- Security patches
- Documentation updates
- Dependency patch version bump

## Implementation

### Release Process

1. **Develop** on feature branches
2. **Create Release PR** with version bump
   - Update `package.json` or `pyproject.toml`
   - Update `CHANGELOG.md`
   - Add git tag: `git tag v1.2.3`
3. **Tag Released** when PR merged to main
4. **Deploy** automatically via GitHub Actions

### Version Constraints for Dependencies

**When consuming libraries:**

```
~1.2.3  # Patch updates only (1.2.x)
^1.2.3  # Minor updates (1.x.x)
1.2.3   # Exact version (pin for stability)
```

### Pre-Release Versions

Used for testing before release:

```
1.0.0-alpha    # Feature incomplete, testing with core team
1.0.0-beta     # Feature complete, testing with broader group
1.0.0-rc.1     # Release candidate, final testing
1.0.0          # Production release
```

### Changelog Format

Keep `CHANGELOG.md` in each repo:

```markdown
## [1.2.0] - 2026-11-12

### Added
- New export functionality

### Changed
- Improved performance by 20%

### Deprecated
- Old API method (use newMethod instead)

### Removed
- Outdated feature

### Fixed
- Critical bug in data validation

### Security
- Fixed XSS vulnerability
```

## Consequences

### Positive
- ✅ **Clear Expectations**: Developers know what to expect
- ✅ **Safe Updates**: Consumers know when it's safe to upgrade
- ✅ **Coordinated Releases**: Teams can plan together
- ✅ **Dependency Management**: Tools can auto-suggest updates
- ✅ **Communication**: Breaking changes are explicit

### Challenges & Mitigations
| Challenge | Mitigation |
|-----------|-----------|
| Defining "breaking" | Document decision criteria; discuss in PR |
| Version fatigue | Batch related changes; release monthly |
| Pre-release confusion | Clear naming: alpha → beta → rc → final |

## Version Support Policy

- **Current Release**: Receives features, fixes, security updates
- **Previous Major**: Receives critical security updates only
- **Older Versions**: No updates (encourage upgrade)

Example:
- 2.x: Full support
- 1.x: Security updates only
- 0.x: Unsupported

## Related ADRs

- ADR-001: Multi-Repository Strategy
- ADR-005: Deployment Approach

## References

- [Semantic Versioning](https://semver.org/)
- [NPM Semver Calculator](https://semver.npmjs.com/)
- [Keep a Changelog](https://keepachangelog.com/)
