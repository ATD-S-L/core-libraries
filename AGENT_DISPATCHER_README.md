# Agent Dispatcher Workflow Guide

Complete guide to the GitHub Actions agent dispatcher system for ATD-S-L repositories.

## Overview

The agent dispatcher automatically routes issues to specialized agents based on labels. This enables:

- **Automatic task assignment** - Issues are routed to the correct agent based on component labels
- **Parallel processing** - Multiple agents can work on different issues simultaneously
- **Consistent workflow** - Standardized branch creation, PR handling, testing, and merging
- **Full context passing** - Agents receive complete issue information automatically

## Quick Start

### 1. Create an Issue

Go to the Issues tab and create a new issue using the **Agent Task** template:

```
Title: [Your task title - min 10 characters]
Description: [Detailed description - min 50 characters]
```

### 2. Add a Component Label

Choose ONE label to route to the appropriate agent:

- **backend** - APIs, database, business logic, integrations
- **frontend** - UI components, state management, styling
- **firmware** - ESP32 drivers, HAL, bootloader, hardware
- **library** - Shared utilities, multi-language libraries

### 3. Watch the Magic ✨

The dispatcher automatically:
1. Validates issue quality
2. Detects the agent label
3. Dispatches the issue to the specialized agent
4. Posts status updates in the issue

## Workflows

### Primary: Automatic Dispatch (agent-dispatch.yml)

**Trigger:** Issue created or labeled with `backend`, `frontend`, `firmware`, or `library`

**Process:**
1. Extract issue metadata (title, body, labels, creator)
2. Validate issue quality (minimum character lengths)
3. Check for required agent label
4. Dispatch to appropriate agent

**Outputs:**
- Posts status comments in the issue
- Creates feature branch for agent
- Passes full context to agent action

**Example:**
```
Issue created: "Implement OAuth login" with label "backend"
↓
Workflow triggers automatically
↓
Issue quality validated ✓
↓
Backend agent dispatched
↓
Comment posted: "✅ Assigned to Backend Agent"
```

### Manual Dispatch (agent-dispatch-manual.yml)

**Use when:** Automatic dispatch is delayed or you need manual control

**Trigger:** Manually via GitHub Actions "Run workflow" button

**Inputs:**
```
issue_number: 1 (required)
agent_type: backend|frontend|firmware|library (required)
```

**How to Use:**

**Option A: GitHub Web UI**
1. Go to Actions tab
2. Click "Manual Agent Dispatch" workflow
3. Click "Run workflow"
4. Enter issue number and agent type
5. Click green "Run workflow" button

**Option B: GitHub CLI**
```bash
gh workflow run agent-dispatch-manual.yml \
  -F issue_number=1 \
  -F agent_type=backend
```

**Option C: Trigger Script (Local)**
```bash
./scripts/trigger-agent.sh --issue 1 --agent backend
```

## Supporting Workflows

### Agent Auto-Merge (agent-auto-merge.yml)

**Trigger:** Pull request created by agent

**Function:**
- Waits for all CI/CD checks to pass
- Automatically merges PR when ready
- Posts completion comment in original issue

### Agent Completion Handler (agent-completion-handler.yml)

**Trigger:** PR merged

**Function:**
- Closes associated issue with completion summary
- Logs task completion metrics
- Updates project board/tracking

### Centro de Control Monitor (centro-de-control-monitor.yml)

**Trigger:** Scheduled (every 5 minutes)

**Function:**
- Monitors active agent tasks
- Checks for stuck or failed workflows
- Posts summary to monitoring channel
- Alerts on failures

## Quality Validation

Issues are automatically validated for minimum quality:

| Requirement | Minimum | Status |
|---|---|---|
| Title length | 10 characters | Required |
| Description length | 50 characters | Required |
| Agent label | 1 of 4 required | Required |

**What happens on validation failure:**
1. Workflow posts error comment in issue
2. Issue remains open for user to fix
3. User edits issue to meet requirements
4. Adding/removing labels re-triggers workflow

**Example validation failure:**
```
❌ Issue quality check failed:

Description too short (minimum 50 characters)

Please update your issue and resubmit.
```

## Debugging & Troubleshooting

### Workflow Not Triggering

**Symptoms:** Issue created but no workflow runs

**Solutions:**

1. **Wait 30-60 seconds** - GitHub Actions can have delays
2. **Verify label** - Issue must have one of: backend, frontend, firmware, library
3. **Check Actions tab** - Go to repository → Actions to see all workflow runs
4. **Use manual dispatch** - Trigger workflow manually via CLI or UI

### Issue Quality Validation Failed

**Symptoms:** Comment says "Title too short" or "Description too short"

**Solutions:**
1. Edit issue to meet minimums (10 char title, 50 char body)
2. Save changes
3. Remove and re-add agent label to re-trigger
4. Workflow automatically re-runs

### Wrong Agent Dispatched

**Symptoms:** Issue routed to wrong component agent

**Solutions:**
1. Remove current label
2. Add correct label (backend/frontend/firmware/library)
3. Workflow automatically re-triggers with correct agent

### Workflow Runs but Agent Never Starts

**Symptoms:** Status comment appears but no PR created

**Check:**
1. GitHub Actions logs for errors
2. Ensure agent can create branches
3. Verify repository permissions

## Agent Task Template

Use the `.github/ISSUE_TEMPLATE/agent-task.md` template when creating issues:

```markdown
## 📋 Description
[Detailed description of what needs to be done]

## 🎯 Acceptance Criteria
- [ ] Core functionality implemented
- [ ] All tests passing with >80% coverage
- [ ] Code follows style guide
- [ ] Documentation updated
- [ ] No breaking changes

## 🏗️ Component & Tech Stack
- [ ] Backend / Frontend / Firmware / Library
[Technology notes]

## 📝 Implementation Notes
- Scope: [What's in/out]
- Dependencies: [Other issues/services]
- Performance: [Any requirements]
- Security: [Any implications]

## ✨ Additional Context
[Attachments, mockups, screenshots, etc.]
```

## Configuration

### Agent Config (.github/agent-config.yml)

```yaml
agents:
  backend:
    repo: "ATD-S-L/apps-backend"
    tier: "critical"
    timeout: "4h"
    
  frontend:
    repo: "ATD-S-L/apps-frontend"
    tier: "critical"
    timeout: "4h"
    
  firmware:
    repo: "ATD-S-L/firmware-esp32"
    tier: "critical"
    timeout: "4h"
    
  library:
    repo: "ATD-S-L/core-libraries"
    tier: "critical"
    timeout: "4h"
```

## Common Workflows

### Adding a New Feature

1. Create issue: "Implement [feature name]"
2. Add component label (backend/frontend/etc)
3. Fill template with acceptance criteria
4. Agent auto-dispatches and implements
5. PR auto-merges on success

### Fixing a Bug

1. Create issue: "Bug: [description]"
2. Add component label
3. Add reproduction steps in description
4. Agent investigates and fixes
5. Tests are added and PR merges

### Refactoring Code

1. Create issue: "Refactor: [module] for [reason]"
2. Add component label
3. List acceptance criteria (tests pass, metrics improve, etc)
4. Agent refactors and verifies metrics
5. PR merges with performance report

## Monitoring & Observability

### Check Dispatcher Status

**In Repository:**
1. Go to Actions tab
2. Filter by workflow: "Route Issue to Specialized Agent"
3. See all triggered dispatches with status

### View Agent Work

**Track Progress:**
1. Original issue → comments show agent status
2. PRs tab → agent's PR with implementation
3. Actions tab → agent's workflow runs

**Example Issue Timeline:**
```
[Opened] User creates issue with "backend" label
  ↓
[Dispatched] Workflow validates and routes to backend agent
  ↓
[Working] Agent creates branch and commits code
  ↓
[PR Created] Agent opens PR with implementation
  ↓
[Testing] CI/CD runs tests
  ↓
[Merged] PR auto-merges on success
  ↓
[Closed] Completion handler closes issue
```

## Best Practices

### Writing Good Issues for Agents

✅ **Do:**
- Be specific about requirements
- Include acceptance criteria
- Link related issues
- Mention any constraints (performance, security)
- Provide examples or mockups
- Use the template

❌ **Don't:**
- Create vague issues
- Skip acceptance criteria
- Add multiple unrelated tasks
- Set unrealistic timeframes
- Forget the component label

### Managing Multiple Tasks

**For related tasks, use issue references:**
```
Depends on: #123
Blocks: #125
Related to: #126
```

**For large features, break into:**
- Backend task (database, API)
- Frontend task (UI, components)
- Testing task (test coverage)

### Monitoring Progress

**Check activity:**
- Issue comments for status updates
- PR for implementation details
- Actions tab for workflow logs
- Release notes for merged changes

## Troubleshooting Checklist

Before reporting issues, verify:

- [ ] Issue has minimum 10 character title
- [ ] Issue has minimum 50 character description
- [ ] Issue has exactly one agent label
- [ ] Waited 60+ seconds for workflow to trigger
- [ ] Checked Actions tab for workflow runs
- [ ] Verified GitHub CLI authentication: `gh auth status`
- [ ] Reviewed workflow logs for errors
- [ ] Tried manual dispatch workflow

## Support & Escalation

**If dispatcher fails after all troubleshooting:**

1. Check `.github/workflows/agent-dispatch.yml` logs
2. Verify dispatch-to-agent action exists
3. Check GitHub Actions logs for errors
4. Document:
   - Issue number
   - Workflow run ID
   - Error message
   - Steps taken

**Manual fallback:**
1. Create feature branch manually
2. Implement changes
3. Open PR
4. Tag `@agent-team` in PR for review

## Documentation

- 📚 [Agent Team Architecture](../AGENTS_TEAM_ARCHITECTURE.md)
- 🚀 [Agent Infrastructure Setup](../AGENT_INFRASTRUCTURE_README.md)
- 🤖 [Agent Orchestration Details](../AGENTS_ORCHESTRATION.md)
- ⚙️ [Automation Flows](../CONTROL_CENTER_AUTOMATION_FLOWS.md)

## Version Info

- **Dispatcher Version:** 2.0 (Enhanced with Manual Dispatch)
- **Last Updated:** 2026-11-12
- **Status:** Production Ready ✅

---

**Questions?** Check the documentation links above or create an issue with the "question" label.
