# Agent Orchestration Technical Implementation

## Overview

This document describes the technical implementation details for coordinating the 4-agent team through GitHub Actions, Centro de Control, and automated workflows.

## GitHub Actions Trigger Architecture

### Webhook Configuration

Each agent repository is configured with a webhook to listen for:
- **Issue opened** with specific labels
- **Issue labeled** (for retroactive assignment)

### Dispatch Workflow

**File**: `.github/workflows/agent-dispatch.yml`

```yaml
name: Route to Agent
on:
  issues:
    types: [opened, labeled]
  
jobs:
  dispatch:
    runs-on: ubuntu-latest
    steps:
      - name: Extract Issue Metadata
        id: extract
        run: |
          LABELS=${{ toJson(github.event.issue.labels.*.name) }}
          TITLE=${{ github.event.issue.title }}
          BODY=${{ github.event.issue.body }}
          ISSUE_NUMBER=${{ github.event.issue.number }}
          echo "labels=$LABELS" >> $GITHUB_OUTPUT
          
      - name: Route to Backend Agent
        if: contains(steps.extract.outputs.labels, 'backend')
        run: |
          curl -X POST https://agent-control-center/dispatch \
            -H "Authorization: Bearer ${{ secrets.AGENT_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{
              "agent": "backend",
              "repo": "${{ github.repository }}",
              "issue_number": ${{ github.event.issue.number }},
              "title": "${{ steps.extract.outputs.title }}",
              "labels": ${{ steps.extract.outputs.labels }}
            }'
      
      - name: Route to Frontend Agent
        if: contains(steps.extract.outputs.labels, 'frontend')
        run: |
          curl -X POST https://agent-control-center/dispatch \
            -H "Authorization: Bearer ${{ secrets.AGENT_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{
              "agent": "frontend",
              "repo": "${{ github.repository }}",
              "issue_number": ${{ github.event.issue.number }},
              "labels": ${{ steps.extract.outputs.labels }}
            }'
      
      - name: Route to Firmware Agent
        if: contains(steps.extract.outputs.labels, 'firmware')
        run: |
          curl -X POST https://agent-control-center/dispatch \
            -H "Authorization: Bearer ${{ secrets.AGENT_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{
              "agent": "firmware",
              "repo": "${{ github.repository }}",
              "issue_number": ${{ github.event.issue.number }},
              "labels": ${{ steps.extract.outputs.labels }}
            }'
      
      - name: Route to Library Agent
        if: contains(steps.extract.outputs.labels, 'library')
        run: |
          curl -X POST https://agent-control-center/dispatch \
            -H "Authorization: Bearer ${{ secrets.AGENT_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{
              "agent": "library",
              "repo": "${{ github.repository }}",
              "issue_number": ${{ github.event.issue.number }},
              "labels": ${{ steps.extract.outputs.labels }}
            }'
```

## Context Passing Protocol

### Issue Data Structure

Each agent receives a standardized context packet:

```json
{
  "id": "unique-agent-task-id",
  "timestamp": "2026-11-12T13:42:15Z",
  "agent": "backend|frontend|firmware|library",
  "source": {
    "repository": "ATD-S-L/apps-backend",
    "issue_number": 123,
    "issue_url": "https://github.com/ATD-S-L/apps-backend/issues/123"
  },
  "requirements": {
    "title": "Feature: Add user authentication",
    "description": "User story describing the feature...",
    "acceptance_criteria": [
      "Users can login with email/password",
      "Sessions persist for 24 hours",
      "Invalid credentials show error message"
    ],
    "labels": ["backend", "priority:high"]
  },
  "context": {
    "branch_base": "main",
    "target_branch": "feature/auth-123",
    "stack": "Node.js/Express/PostgreSQL",
    "estimated_effort": "3-5 hours"
  },
  "resources": {
    "agent_token": "ghp_xxxxxxxxxxxx",
    "pr_auto_merge": true,
    "ci_timeout_minutes": 30
  }
}
```

## Agent Initialization

### Setup Steps (Per Agent)

1. **Clone Repository**
   ```bash
   git clone https://github.com/ATD-S-L/[repo-name].git
   cd [repo-name]
   git checkout -b feature/issue-[number]
   ```

2. **Install Dependencies**
   ```bash
   # Backend
   npm install && npm run setup
   
   # Frontend
   npm install && npm run setup
   
   # Firmware
   source $IDF_PATH/export.sh && idf.py install-python-packages
   
   # Library
   npm install && pip install -r requirements.txt
   ```

3. **Load Configuration**
   - Read `.env.agent` for environment setup
   - Load build configuration from `.github/agent-config.yml`
   - Initialize database/test environment if needed

## Implementation Workflow

### Phase 1: Analysis (30 min)
```
Agent receives issue context:
├─ Parse requirements
├─ Identify acceptance criteria
├─ Determine scope and complexity
├─ Check for missing information
└─ Plan implementation approach
```

### Phase 2: Implementation (1-3 hours)
```
Agent implements solution:
├─ Write code following style guides
├─ Create necessary tests
├─ Add inline documentation
├─ Run local linting
└─ Verify functionality locally
```

### Phase 3: Testing (30-45 min)
```
Agent validates implementation:
├─ Run unit tests (target: >80% coverage)
├─ Run integration tests
├─ Run E2E tests (if applicable)
├─ Check for security vulnerabilities
├─ Verify performance benchmarks
└─ Generate coverage reports
```

### Phase 4: Documentation (15-30 min)
```
Agent generates documentation:
├─ Write/update API documentation
├─ Add code comments
├─ Create/update README sections
├─ Generate changelog entry
└─ Add examples if applicable
```

### Phase 5: Pull Request (15 min)
```
Agent creates PR:
├─ Push feature branch to remote
├─ Create PR with auto-generated title
├─ Link to original issue
├─ Add PR description with:
│  ├─ What changed
│  ├─ How to test
│  ├─ Breaking changes (if any)
│  └─ Related issues/PRs
└─ Request CI/CD pipeline
```

## CI/CD Integration

### Mandatory Checks (Must Pass Before Merge)

```yaml
checks:
  - name: unit-tests
    timeout: 15m
    threshold: 80% coverage
    
  - name: integration-tests
    timeout: 20m
    fail_on: any failure
    
  - name: linting
    tools: [eslint, prettier, black, clippy]
    fail_on: violations
    
  - name: security-scan
    tools: [npm-audit, bandit, clippy-lint]
    fail_on: medium+ severity
    
  - name: type-checking
    tools: [TypeScript, mypy, clippy]
    fail_on: any error
    
  - name: performance-benchmark
    baseline: main branch
    threshold: not worse than -5%
    
  - name: accessibility-audit
    applies_to: frontend only
    threshold: WCAG 2.1 Level AA
```

### Auto-Merge Policy

```javascript
if (
  allMandatoryChecksPassed &&
  codeQualityThresholdsMetOrExceeded &&
  noConflictsWithMainBranch &&
  prAuthorIsAuthorizedAgent
) {
  mergePullRequest({
    strategy: "squash",
    deleteHeadBranch: true,
    autoDeleteHead: true
  });
}
```

## Error Handling & Retry Logic

### Retry Mechanism

```javascript
class AgentRetryManager {
  async executeWithRetry(task, maxRetries = 3) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await task.execute();
      } catch (error) {
        if (this.isRetryable(error) && attempt < maxRetries) {
          const delay = Math.pow(2, attempt - 1) * 1000; // Exponential backoff
          await this.sleep(delay);
          console.log(`Retry attempt ${attempt}/${maxRetries} after ${delay}ms`);
        } else {
          return {
            status: "failed",
            error: error.message,
            failureType: error.type,
            retryCount: attempt - 1
          };
        }
      }
    }
  }
  
  isRetryable(error) {
    return [
      "NETWORK_ERROR",
      "TIMEOUT",
      "RATE_LIMIT",
      "TEMPORARY_SERVICE_ERROR"
    ].includes(error.type);
  }
}
```

### Failure Reporting

On failure, agent reports to Centro de Control:

```json
{
  "status": "failed",
  "issue_number": 123,
  "agent": "backend",
  "failure_stage": "testing",
  "error": "Test coverage below threshold (65% < 80%)",
  "logs_url": "https://github.com/ATD-S-L/apps-backend/actions/run/12345",
  "recommendations": [
    "Add tests for error handling paths",
    "Improve branch coverage for edge cases"
  ],
  "manual_intervention_required": false,
  "recovery_action": "automatic_retry_scheduled"
}
```

## Result Reporting

### Success Report

```json
{
  "status": "completed",
  "issue_number": 123,
  "agent": "backend",
  "results": {
    "pr_url": "https://github.com/ATD-S-L/apps-backend/pull/456",
    "pr_number": 456,
    "merged_at": "2026-11-12T14:35:22Z",
    "metrics": {
      "files_changed": 12,
      "lines_added": 342,
      "lines_removed": 18,
      "test_coverage": "89%",
      "ci_duration_minutes": 8.5
    },
    "artifacts": {
      "documentation": "https://docs.atd-sl.io/api/auth",
      "changelog": "CHANGELOG.md",
      "release_version": "2.1.0"
    }
  }
}
```

### Notification Schema

Centro de Control sends notifications to:
- Slack/Teams: Real-time completion status
- Email: Daily digest of completed tasks
- GitHub: Comments on original issue with summary

## Monitoring & Observability

### Metrics Collected

```
Per Agent:
- Task completion rate (%)
- Average task duration (minutes)
- Success rate (%)
- Test coverage (%)
- Code review feedback (avg comments)
- PR merge time (minutes)

Per Repository:
- Issues resolved per day
- Backlog trend
- Error rate (%)
- CI/CD reliability (%)
```

### Dashboard Components

1. **Real-Time Status**
   - Active tasks per agent
   - Current bottlenecks
   - Resource utilization

2. **Historical Metrics**
   - Completion trends
   - Quality metrics
   - Performance trends

3. **Alerts**
   - Failed CI/CD pipelines
   - Exceeded SLAs
   - Resource constraints

## Security Considerations

### Token Management

- Each agent uses repository-scoped GitHub App tokens
- Tokens rotated every 90 days
- Never logged or exposed in CI/CD output
- Separate tokens per repository

### Access Control

- Agents can only push to designated branches
- Pull requests require automated checks
- No direct access to main/production branches
- All actions logged and audited

### Data Protection

- Secrets stored in GitHub encrypted secrets
- No sensitive data in logs
- PR descriptions sanitized
- Compliance with data retention policies

---

**Last Updated**: 2026-11-12  
**Version**: 1.0  
**Owner**: Centro de Control Team
