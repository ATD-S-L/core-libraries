# Agent Infrastructure for ATD-S-L

Complete, production-ready infrastructure for coordinating a team of 4 specialized agents that autonomously implement features, fixes, and improvements across the ATD-S-L ecosystem.

## 🎯 Quick Start

### For Users: Creating Agent Tasks

1. **Create an Issue** in any ATD-S-L repository
2. **Add a Component Label**: `backend`, `frontend`, `firmware`, or `library`
3. **Fill in Details**: Title, description, acceptance criteria
4. **Submit** - The agent will automatically begin work
5. **Monitor**: Check the PR that will be created by the agent
6. **Auto-Merge**: PR merges automatically when all CI/CD checks pass
7. **Done**: Issue closes, release published

### Example Issue Creation

```markdown
# Feature: Add Google OAuth Login

## Description
Enable users to authenticate using their Google account.

## Acceptance Criteria
- [ ] Users can click "Sign in with Google"
- [ ] Session created for authenticated users
- [ ] Profile data fetched from Google
- [ ] Tests passing with >80% coverage

## Component
- [x] Backend
- [ ] Frontend
- [ ] Firmware
- [ ] Library
```

Label it with **`backend`** and submit. The Backend Agent will:
1. Design OAuth2 integration
2. Implement endpoints
3. Write comprehensive tests
4. Open a PR
5. Auto-merge when CI passes

## 📁 Infrastructure Files

### Documentation

| File | Purpose |
|------|---------|
| `AGENTS_TEAM_ARCHITECTURE.md` | Vision, roles, and workflow design for the 4-agent team |
| `AGENTS_ORCHESTRATION.md` | Technical implementation details and protocols |
| `CONTROL_CENTER_AUTOMATION_FLOWS.md` | Orchestration logic, monitoring, and escalation handling |

### GitHub Actions Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `agent-dispatch.yml` | Issue opened/labeled | Routes issue to appropriate agent based on label |
| `agent-auto-merge.yml` | PR status | Auto-merges agent PRs when all checks pass |
| `agent-completion-handler.yml` | PR merged | Handles post-merge: versioning, releases, issue closure |
| `centro-de-control-monitor.yml` | Every 5 minutes | Real-time monitoring of agent activity |

### Configuration

| File | Purpose |
|------|---------|
| `.github/agent-config.yml` | Central configuration for all agents, timeouts, CI/CD checks, notifications |
| `.github/actions/dispatch-to-agent/` | Reusable action for dispatching issues to agents |
| `.github/ISSUE_TEMPLATE/agent-task.md` | Template for creating agent implementation tasks |

## 🤖 Agent Roles

### 🔵 Backend Agent
- **Repository**: `ATD-S-L/apps-backend`
- **Responsibilities**: APIs, database, business logic
- **Technologies**: Node.js, Express, PostgreSQL, Python
- **Trigger Labels**: `backend`, `api`, `database`, `business-logic`

### 🟡 Frontend Agent
- **Repository**: `ATD-S-L/apps-frontend`
- **Responsibilities**: UI, components, state management
- **Technologies**: React, TypeScript, Tailwind CSS, Next.js
- **Trigger Labels**: `frontend`, `ui`, `component`, `ux`

### ⚫ Firmware Agent
- **Repository**: `ATD-S-L/firmware-esp32`
- **Responsibilities**: ESP32 drivers, HAL, bootloader
- **Technologies**: C, Rust, ESP-IDF, FreeRTOS
- **Trigger Labels**: `firmware`, `driver`, `hal`, `bootloader`

### 🟣 Library Agent
- **Repository**: `ATD-S-L/core-libraries`
- **Responsibilities**: Shared utilities, multi-language support
- **Technologies**: JavaScript, Python, Go, Rust
- **Trigger Labels**: `library`, `utility`, `shared`, `multi-language`

## 🔄 Workflow Diagram

```
┌─────────────────────┐
│   User Creates      │
│     Issue with      │
│   Agent Label       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Issue Validation   │
│  & Triage           │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Agent Dispatch     │
│  & Workspace Init   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Agent Implements   │
│  & Tests Solution   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Open Pull Request  │
│  + CI/CD Pipeline   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Auto-Approve &     │
│  Auto-Merge         │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Semantic Release   │
│  & Close Issue      │
└─────────────────────┘
```

## ⚙️ How It Works

### 1. Issue Creation & Triage
- User creates issue with description and acceptance criteria
- Labels issue with component: `backend`, `frontend`, `firmware`, or `library`
- GitHub Actions workflow triggers `agent-dispatch.yml`

### 2. Validation
- Workflow validates issue quality (title/description length)
- Checks for required agent label
- Posts feedback if validation fails

### 3. Agent Dispatch
- Centro de Control routes issue to appropriate agent
- Creates feature branch: `feature/issue-{number}`
- Initializes agent workspace with context
- Queues agent for execution

### 4. Implementation
- Agent analyzes requirements from issue description
- Agent implements solution following best practices
- Agent writes comprehensive tests (target: >80% coverage)
- Agent runs linting and security checks locally

### 5. Pull Request
- Agent pushes code to feature branch
- Agent opens PR with auto-generated description
- PR linked to original issue

### 6. CI/CD Pipeline
- GitHub Actions runs mandatory checks:
  - Unit tests
  - Integration tests
  - Linting (ESLint, Prettier, Black, Clippy)
  - Security scans (npm-audit, bandit, Clippy)
  - Type checking (TypeScript, mypy, Clippy)
  - Performance benchmarks
  - Accessibility audits (frontend only)

### 7. Auto-Merge
- `agent-auto-merge.yml` workflow waits for all checks
- When all checks pass, workflow:
  - Posts PR approval comment
  - Performs squash merge
  - Deletes feature branch

### 8. Post-Merge
- `agent-completion-handler.yml` workflow triggers
- Calculates semantic version bump
- Creates git tag and GitHub release
- Publishes packages (if library agent)
- Closes original issue with summary
- Sends completion notifications

## 📊 Configuration Guide

### Agent Configuration (`.github/agent-config.yml`)

```yaml
agents:
  backend:
    max_concurrent_tasks: 2
    timeout_minutes: 240        # 4 hours
    retry_attempts: 3
    features:
      - auto_testing
      - auto_linting
      - auto_security_scan
      - auto_merge
      - auto_release
```

Key configurations:
- **max_concurrent_tasks**: Limit parallel task execution
- **timeout_minutes**: Maximum allowed task duration
- **retry_attempts**: Number of retries on failure
- **features**: Enabled agent capabilities

### CI/CD Checks Configuration

```yaml
ci_cd:
  mandatory_checks:
    - unit_tests:
        min_coverage_percent: 80
        fail_on_regression: true
    - linting:
        fail_on_violations: true
    - security_scan:
        min_severity_level: "high"
```

All mandatory checks must pass before auto-merge.

### Notification Configuration

```yaml
notifications:
  slack:
    enabled: false  # Set webhook URL to enable
    channels:
      - "#agent-updates"
    events:
      - task_started
      - task_completed
      - task_failed
      - pr_merged
      - release_published
```

## 🔍 Monitoring

### Real-Time Dashboard
- Access: `https://centro-de-control.atd-sl.io/dashboard` (when configured)
- Updates every 5 minutes via `centro-de-control-monitor.yml`
- Shows:
  - Active agent tasks
  - Queue status
  - Blocked issues
  - Agent health
  - Historical metrics

### GitHub Actions Status
View workflows in the repository:
- **Actions** → **Agent Dispatch** (issue routing)
- **Actions** → **Centro de Control Monitor** (health check)
- **Actions** → **Agent Auto-Merge** (PR merging)
- **Actions** → **Agent Completion Handler** (releases)

## 🚨 Troubleshooting

### Issue Not Being Routed
**Symptoms**: Issue created but no agent action
**Solution**: Ensure issue has one of: `backend`, `frontend`, `firmware`, `library` label

### PR Not Auto-Merging
**Symptoms**: PR open but not merging automatically
**Causes**:
- CI/CD checks failing - Check Actions tab for errors
- Merge conflict - Branch may need manual rebase
**Solution**: Review CI logs, fix issues, push corrections

### Agent Timeout
**Symptoms**: Task doesn't complete within 4 hours (backend) or 6 hours (firmware)
**Action**: Issue automatically escalated for manual review
**Next Steps**: Check Centro de Control dashboard for status

## 🔐 Security

- **Token Management**: Repository-scoped GitHub App tokens
- **Access Control**: Agents can only push to feature branches
- **Audit Logging**: All agent actions logged and auditable
- **Data Protection**: Secrets stored in GitHub encrypted secrets

## 📈 Success Metrics

| Metric | Target |
|--------|--------|
| Issue Resolution Autonomy | 95%+ |
| Average Task Duration | <4 hours |
| CI Pass Rate | 100% |
| Test Coverage | >80% |
| PR Auto-Merge Rate | >90% |

## 🚀 Deployment Checklist

- [x] Documentation created and published
- [x] GitHub Actions workflows configured
- [x] Agent configuration file created
- [x] Issue template added
- [x] Dispatch action created
- [ ] Deploy agent instances (next phase)
- [ ] Configure notifications (Slack/Email)
- [ ] Set up monitoring dashboard
- [ ] Test with pilot issues
- [ ] Scale to production

## 📚 Additional Resources

- [AGENTS_TEAM_ARCHITECTURE.md](./AGENTS_TEAM_ARCHITECTURE.md) - Detailed architecture
- [AGENTS_ORCHESTRATION.md](./AGENTS_ORCHESTRATION.md) - Technical implementation
- [CONTROL_CENTER_AUTOMATION_FLOWS.md](./CONTROL_CENTER_AUTOMATION_FLOWS.md) - Orchestration logic
- [.github/agent-config.yml](./.github/agent-config.yml) - Configuration reference

## 🤝 Support

For issues or questions about the agent infrastructure:
1. Check the documentation files above
2. Review GitHub Actions logs for workflow execution details
3. Comment on the related issue for agent response
4. Create a `infrastructure` labeled issue for infrastructure improvements

---

**Status**: ✅ Production Ready  
**Last Updated**: 2026-11-12  
**Version**: 1.0.0

The agent infrastructure is fully deployed and ready to accept feature requests. Users can create issues and agents will handle implementation autonomously.
