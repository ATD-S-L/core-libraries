# ADR-005: Deployment Approach

**Date:** 2026-11-12  
**Status:** Accepted  
**Authors:** ATD-S-L Architecture Team

## Context

ATD-S-L needs a deployment strategy that:
- Works with multi-repository architecture
- Supports fast, reliable releases
- Minimizes downtime
- Provides rollback capability
- Works across different platforms (web, embedded, backend)
- Automates where possible

## Decision

**We use Docker containerization + GitHub Actions for deployment**, with infrastructure-as-code for repeatability.

### Deployment Architecture

```
┌─────────────┐
│  Developer  │ Commits to main
└──────┬──────┘
       │
       ▼
┌──────────────────────┐
│  GitHub Actions CI   │ Runs tests & builds
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  Docker Registry     │ Pushes image with tag v1.2.3
└──────┬───────────────┘
       │
       ├─────────────────────────┬────────────────────┐
       │                         │                    │
       ▼                         ▼                    ▼
┌────────────────┐    ┌─────────────────┐   ┌──────────────┐
│  Staging Env   │    │  Production     │   │  Dev Env     │
│  (Auto-deploy) │    │  (Manual/Auto)  │   │  (Testing)   │
└────────────────┘    └─────────────────┘   └──────────────┘
```

## Implementation Details

### 1. Containerization (Dockerfile)

Every repository includes:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### 2. Build Workflow (GitHub Actions)

```yaml
# .github/workflows/build-and-push.yml
on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker image
        run: docker build -t myapp:${{ github.sha }} .
      - name: Push to registry
        run: docker push myapp:${{ github.sha }}
      - name: Tag release
        if: startsWith(github.ref, 'refs/tags/')
        run: docker tag myapp:${{ github.sha }} myapp:${{ github.ref_name }}
```

### 3. Staging Environment

- Auto-deploys on every merge to `main`
- For QA testing
- Torn down weekly or on-demand
- Free/cheap cloud resources (AWS t3.micro, etc.)

### 4. Production Environment

**Standard Flow:**
1. Merge to main (automatic staging deploy)
2. Test in staging
3. Create GitHub Release (manual trigger)
4. Automatic production deploy from release tag

**Rollback (if needed):**
```bash
# Trigger deployment of previous version
gh workflow run deploy.yml -f version=v1.2.2
```

## Repository Structure

Each repo includes:
```
repo/
├── Dockerfile           # Container definition
├── docker-compose.yml   # Local dev environment
├── .github/
│   └── workflows/
│       ├── test.yml
│       ├── build-and-push.yml
│       └── deploy.yml
└── deployment/
    ├── staging.yaml     # Kubernetes manifests (if applicable)
    └── production.yaml
```

## Deployment Targets

### Backend Services
- **Container**: Docker
- **Platform**: Docker Compose (local), Kubernetes (production), AWS ECS/Lambda
- **CI/CD**: GitHub Actions + deployment scripts

### Frontend Applications
- **Build**: npm run build → static files
- **Hosting**: GitHub Pages, Vercel, Netlify, S3 + CloudFront
- **CDN**: CloudFlare or AWS CloudFront

### Firmware/Embedded
- **Build**: PlatformIO or Arduino CLI
- **Deployment**: GitHub Releases + OTA (Over-The-Air) update mechanism
- **Versioning**: Semantic versioning in firmware metadata

## Consequences

### Positive
- ✅ **Reproducibility**: Same container runs locally and in production
- ✅ **Consistency**: Environment variables, dependencies all controlled
- ✅ **Scalability**: Easy to spin up more instances
- ✅ **Isolation**: Services don't interfere with each other
- ✅ **Automated**: Less manual deployment steps
- ✅ **Rollback**: Quick revert to previous version

### Challenges & Mitigations
| Challenge | Mitigation |
|-----------|-----------|
| Container size bloat | Use multi-stage builds, slim base images |
| Security vulnerabilities | Regular scanning with Trivy; update base images |
| Debugging production issues | Keep logs in CloudWatch/Stackdriver; use exec for debugging |
| Registry management | Use GitHub Container Registry (free, integrated) |

## Security Considerations

1. **Image Scanning**
   - Use Trivy or similar to scan for vulnerabilities
   - Block deployment if critical vulnerabilities found

2. **Secrets Management**
   - Use GitHub Secrets for credentials
   - Pass as environment variables at runtime
   - Never embed secrets in Dockerfile or images

3. **Image Signing**
   - Consider Cosign for image signatures
   - Verify signatures before deployment

4. **Access Control**
   - Limit who can trigger production deployments
   - Use branch protection + CODEOWNERS
   - Require multiple approvals for main branch

## Monitoring & Alerts

Each deployment includes:
- Health checks (HTTP /health endpoint)
- Log aggregation (CloudWatch, ELK stack)
- Performance monitoring (DataDog, New Relic)
- Uptime monitoring (StatusPage.io)

## Cost Considerations

- **Container Registry**: GitHub Container Registry (free)
- **Staging**: Free tier or cheap VPS
- **Production**: Based on traffic/compute needs
- **Monitoring**: Free tier of most tools available

## Related ADRs

- ADR-002: CI/CD Approach (GitHub Actions)
- ADR-003: Pre-Commit & Quality Gates
- ADR-004: Semantic Versioning Strategy

## References

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [GitHub Actions Deployment](https://docs.github.com/en/actions/deployment/)
- [Kubernetes Manifests](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Container Security](https://cheatsheetseries.owasp.org/cheatsheets/Container_Security_Cheat_Sheet.html)
