# Centro de Control - Automation Flows & Management

## Overview

Centro de Control is the central coordination hub that manages all 4 specialized agents. It monitors progress, handles escalations, prioritizes work, and ensures seamless multi-agent orchestration.

## Architecture

```
┌────────────────────────────────────────────────────────┐
│         GitHub Issues (Across 4 Repositories)          │
└────────────────────────┬───────────────────────────────┘
                         │
                    GitHub Webhooks
                         │
         ┌───────────────┴───────────────┐
         │                               │
┌────────v──────────────────────────────────────────────┐
│     Centro de Control - Orchestration Engine           │
│  ┌──────────────────────────────────────────────────┐ │
│  │ 1. Issue Receiver & Triage                       │ │
│  │ 2. Agent Router & Dispatcher                     │ │
│  │ 3. Progress Monitor & Dashboard                  │ │
│  │ 4. Conflict Resolution & Escalation              │ │
│  │ 5. Auto-Merge & Release Coordinator              │ │
│  │ 6. Metrics & Reporting Engine                    │ │
│  └──────────────────────────────────────────────────┘ │
└────────┬────────────────┬────────────────┬────────────┘
         │                │                │
    ┌────v─────┐     ┌────v────┐     ┌────v────┐    ┌────────┐
    │ Backend  │     │Frontend │     │Firmware │    │Library │
    │  Agent   │     │ Agent   │     │ Agent   │    │ Agent  │
    └──────────┘     └─────────┘     └─────────┘    └────────┘
         │                │                │
    [Implementation]  [Implementation]  [Implementation]
         │                │                │
    ┌────v─────────────────v─────────────v────────────┐
    │     CI/CD Pipelines & Test Environments          │
    └──────────────────────────────────────────────────┘
         │
    ┌────v─────────────────────────────────────────────┐
    │     Auto-Merge, Release & Notifications           │
    └──────────────────────────────────────────────────┘
```

## Core Flows

### Flow 1: Issue Receipt & Triage

**Trigger**: New issue created or labeled

```javascript
async function receiveAndTriageIssue(issuePayload) {
  const issue = {
    id: issuePayload.issue.id,
    number: issuePayload.issue.number,
    title: issuePayload.issue.title,
    body: issuePayload.issue.body,
    labels: issuePayload.issue.labels.map(l => l.name),
    repository: issuePayload.repository.full_name,
    createdAt: issuePayload.issue.created_at,
    creator: issuePayload.issue.user.login
  };

  // Validate issue quality
  const validation = validateIssue(issue);
  if (!validation.isValid) {
    await postComment(issue, `❌ Issue needs refinement:\n${validation.errors.join('\n')}`);
    return;
  }

  // Determine agent assignment
  const agentLabel = issue.labels.find(l => 
    ['backend', 'frontend', 'firmware', 'library'].includes(l)
  );
  
  if (!agentLabel) {
    await postComment(issue, "⚠️ Please add one of: backend, frontend, firmware, library");
    return;
  }

  // Create assignment record
  const assignment = await createAssignment({
    issueNumber: issue.number,
    repository: issue.repository,
    agent: agentLabel,
    priority: extractPriority(issue.labels),
    estimatedEffort: estimateEffort(issue.body),
    assignedAt: new Date(),
    status: 'assigned'
  });

  // Add to queue
  await enqueueAgentTask(assignment);
  
  // Post acknowledgment
  await postComment(issue, `✅ Assigned to ${agentLabel} agent. Working on it now.`);
  
  return assignment;
}

function validateIssue(issue) {
  const errors = [];
  
  if (!issue.title || issue.title.length < 10) {
    errors.push("Title too short (min 10 chars)");
  }
  
  if (!issue.body || issue.body.length < 50) {
    errors.push("Description too short (min 50 chars)");
  }
  
  if (issue.labels.length === 0) {
    errors.push("At least one label required");
  }
  
  return {
    isValid: errors.length === 0,
    errors
  };
}

function extractPriority(labels) {
  if (labels.includes('priority:critical')) return 1;
  if (labels.includes('priority:high')) return 2;
  if (labels.includes('priority:medium')) return 3;
  return 4; // default: low
}
```

### Flow 2: Agent Dispatch & Monitoring

**Trigger**: Issue assigned to agent

```javascript
async function dispatchToAgent(assignment) {
  const agent = createAgentWorker(assignment.agent);
  
  const taskId = generateTaskId();
  const task = {
    id: taskId,
    assignment,
    status: 'dispatched',
    startedAt: new Date(),
    events: []
  };

  // Log event
  await logEvent(taskId, {
    stage: 'dispatch',
    agent: assignment.agent,
    message: `Task dispatched to ${assignment.agent} agent`,
    timestamp: new Date()
  });

  // Start monitoring
  const monitor = startAgentMonitor(taskId, assignment.agent, {
    checkInterval: 30000, // 30 seconds
    timeout: 4 * 60 * 60 * 1000, // 4 hours
    onProgress: (event) => handleAgentProgress(taskId, event),
    onError: (error) => handleAgentError(taskId, error),
    onComplete: (result) => handleAgentCompletion(taskId, result)
  });

  // Execute agent task
  try {
    await agent.execute({
      ...assignment,
      taskId,
      onStatusUpdate: (status) => updateTaskStatus(taskId, status)
    });
  } catch (error) {
    await handleAgentError(taskId, error);
  }

  return taskId;
}

async function handleAgentProgress(taskId, event) {
  const task = await getTask(taskId);
  
  // Log progress
  task.events.push({
    type: 'progress',
    stage: event.stage,
    message: event.message,
    timestamp: new Date()
  });

  // Update dashboard in real-time
  await broadcastDashboardUpdate({
    taskId,
    status: task.status,
    progress: event.progress,
    currentStage: event.stage
  });

  // Save
  await saveTask(task);
}

async function handleAgentError(taskId, error) {
  const task = await getTask(taskId);
  const assignment = task.assignment;

  // Categorize error
  const errorType = categorizeError(error);
  
  // Log error
  task.events.push({
    type: 'error',
    errorType,
    message: error.message,
    timestamp: new Date(),
    stack: error.stack
  });

  // Attempt recovery
  if (isRetryable(errorType)) {
    const retries = task.events.filter(e => e.type === 'retry').length;
    if (retries < 3) {
      console.log(`Retrying task ${taskId} (attempt ${retries + 1})`);
      await saveTask(task);
      
      // Schedule retry with exponential backoff
      const delay = Math.pow(2, retries) * 5000;
      setTimeout(() => dispatchToAgent(assignment), delay);
      return;
    }
  }

  // Escalate if not recoverable
  task.status = 'blocked';
  await saveTask(task);
  
  await escalateTask(taskId, {
    reason: errorType,
    message: error.message,
    needsManualIntervention: !isRetryable(errorType),
    suggestedAction: generateRecoveryAction(errorType)
  });

  // Notify
  await postIssueComment(assignment.issueNumber, 
    `⚠️ **Task blocked**: ${error.message}\n\n` +
    `**Action**: ${generateRecoveryAction(errorType)}`
  );
}

async function handleAgentCompletion(taskId, result) {
  const task = await getTask(taskId);
  
  // Log completion
  task.events.push({
    type: 'completed',
    prUrl: result.prUrl,
    prNumber: result.prNumber,
    metrics: result.metrics,
    timestamp: new Date()
  });

  task.status = 'completed';
  task.completedAt = new Date();
  task.duration = task.completedAt - task.startedAt;

  // Save
  await saveTask(task);

  // Move to approval stage
  await approveAndMerge(taskId, result);
}
```

### Flow 3: Auto-Approve & Merge Coordination

**Trigger**: Agent completes work and opens PR

```javascript
async function approveAndMerge(taskId, result) {
  const task = await getTask(taskId);
  const { prNumber, prUrl } = result;

  // Wait for CI to complete
  const ciStatus = await waitForCICompletion(prNumber, {
    maxWait: 30 * 60 * 1000, // 30 minutes
    checkInterval: 10000
  });

  if (ciStatus.status === 'failure') {
    // Handle CI failure
    await handleCIFailure(taskId, ciStatus);
    return;
  }

  if (ciStatus.status !== 'success') {
    // Timeout or unknown status
    await escalateTask(taskId, {
      reason: 'CI_TIMEOUT',
      message: `CI pipeline did not complete within timeout`,
      needsManualIntervention: true
    });
    return;
  }

  // All checks passed, auto-approve
  await approvePullRequest(prNumber, {
    reviewer: 'Centro de Control',
    comment: '✅ All automated checks passed. Proceeding with merge.'
  });

  // Execute merge
  const mergeResult = await mergePullRequest(prNumber, {
    strategy: 'squash',
    deleteHeadBranch: true,
    commitTitle: task.assignment.title
  });

  if (mergeResult.merged) {
    // Log merge
    task.events.push({
      type: 'merged',
      mergedAt: new Date(),
      mergeCommit: mergeResult.sha,
      deletedBranch: mergeResult.branchDeleted
    });

    // Trigger post-merge workflows
    await triggerPostMerge(taskId, mergeResult);
  } else {
    // Merge conflict or other issue
    await handleMergeFailure(taskId, mergeResult);
  }
}

async function handleCIFailure(taskId, ciStatus) {
  const task = await getTask(taskId);
  const { failedChecks, logs } = ciStatus;

  // Analyze failure
  const analysis = await analyzeFailure(failedChecks, logs);

  // Log
  task.events.push({
    type: 'ci_failure',
    failedChecks,
    analysis,
    timestamp: new Date()
  });

  task.status = 'blocked';
  await saveTask(task);

  // Post comment with analysis
  const prNumber = task.assignment.issueNumber;
  await postPullRequestComment(prNumber,
    `❌ **CI/CD Pipeline Failed**\n\n` +
    `**Failed Checks**: ${failedChecks.join(', ')}\n\n` +
    `**Analysis**: ${analysis.summary}\n\n` +
    `**Suggestions**:\n${analysis.suggestions.map(s => `- ${s}`).join('\n')}`
  );

  // Check if auto-recoverable
  if (analysis.isAutoRecoverable) {
    // Agent will receive feedback and retry
    console.log(`Task ${taskId} scheduled for agent retry`);
  } else {
    // Needs manual review
    await escalateTask(taskId, {
      reason: 'CI_FAILURE',
      message: analysis.summary,
      needsManualIntervention: true,
      failureDetails: {
        checks: failedChecks,
        analysis: analysis.detailed
      }
    });
  }
}
```

### Flow 4: Post-Merge & Release

**Trigger**: PR merged to main

```javascript
async function triggerPostMerge(taskId, mergeResult) {
  const task = await getTask(taskId);
  const assignment = task.assignment;

  // Step 1: Semantic versioning
  const newVersion = await bumpVersion(assignment.repository, {
    strategy: detectVersionStrategy(task.assignment.body),
    prerelease: assignment.labels?.includes('prerelease')
  });

  // Step 2: Generate changelog
  const changelog = await generateChangelog({
    repository: assignment.repository,
    fromTag: await getLatestTag(),
    toCommit: mergeResult.sha,
    format: 'markdown'
  });

  // Step 3: Publish artifacts
  const artifacts = {};
  
  if (assignment.agent === 'library') {
    // Publish to package managers
    artifacts.npm = await publishToNpm(assignment.repository, newVersion);
    artifacts.pypi = await publishToPyPI(assignment.repository, newVersion);
    artifacts.cargo = await publishToCargo(assignment.repository, newVersion);
  }

  // Step 4: Create GitHub release
  const release = await createGitHubRelease({
    repository: assignment.repository,
    tagName: newVersion,
    name: `Release ${newVersion}`,
    body: changelog,
    draft: false,
    prerelease: assignment.labels?.includes('prerelease'),
    artifacts
  });

  // Step 5: Close original issue
  await closeIssue(assignment.issueNumber, {
    comment: `✅ **Completed and Released**\n\n` +
             `- **PR**: ${task.events.find(e => e.type === 'completed').prUrl}\n` +
             `- **Release**: ${release.url}\n` +
             `- **Version**: ${newVersion}\n\n` +
             `**Metrics**: ${formatMetrics(task.events.find(e => e.type === 'completed').metrics)}`
  });

  // Step 6: Send notifications
  await notifyCompletion(taskId, {
    status: 'released',
    version: newVersion,
    releaseUrl: release.url,
    changedFiles: task.events.find(e => e.type === 'completed').metrics.files_changed
  });

  // Step 7: Log completion
  task.events.push({
    type: 'released',
    version: newVersion,
    releaseUrl: release.url,
    artifacts,
    timestamp: new Date()
  });

  task.status = 'released';
  await saveTask(task);
}
```

### Flow 5: Real-Time Monitoring Dashboard

**Access**: `https://centro-de-control.atd-sl.io/dashboard`

**Components**:

1. **Active Tasks Panel**
   ```
   ┌─────────────────────────────────────────┐
   │ Active Tasks (Real-Time)                │
   ├─────────────────────────────────────────┤
   │ [Backend]  Issue #123: Add auth       │ 55%
   │   Stage: Testing                        │
   │   Duration: 45m / ~90m estimated        │
   │                                         │
   │ [Frontend] Issue #124: Login UI       │ 30%
   │   Stage: Implementation                 │
   │   Duration: 25m / ~90m estimated        │
   │                                         │
   │ [Firmware] Issue #125: WiFi driver    │ 80%
   │   Stage: Documentation                  │
   │   Duration: 2h15m / ~3h estimated       │
   │                                         │
   │ [Library]  Issue #126: Utils v2.0     │ 100%
   │   Stage: Completed (Merged)             │
   │   Duration: 2h45m                       │
   └─────────────────────────────────────────┘
   ```

2. **Queue & Backlog**
   ```
   Queued Tasks (12)              Blocked Tasks (2)
   ├─ Priority 1: 2               ├─ #118: CI Failure
   ├─ Priority 2: 5               └─ #119: Needs Info
   ├─ Priority 3: 4
   └─ Priority 4: 1
   ```

3. **Historical Metrics**
   - Daily completion rate
   - Average task duration by agent
   - Success rate (%)
   - Test coverage trends
   - Release frequency

4. **Alerts & Issues**
   - Red: Blocked tasks (manual intervention needed)
   - Yellow: Tasks exceeding SLA
   - Green: On track

## Escalation & Manual Intervention

### Escalation Triggers

```javascript
const escalationTriggers = {
  timeout: {
    threshold: 4 * 60 * 60 * 1000, // 4 hours
    action: 'notify_on_call_engineer',
    priority: 'high'
  },
  
  ci_failure: {
    retries: 3,
    action: 'review_by_code_owner',
    priority: 'medium'
  },
  
  conflicts: {
    threshold: 1, // Any conflict
    action: 'manual_merge_resolution',
    priority: 'high'
  },
  
  missing_info: {
    threshold: 1, // Agent detected incomplete requirements
    action: 'request_clarification_from_issue_creator',
    priority: 'medium'
  }
};

async function checkEscalationTriggers(task) {
  const now = new Date();
  const duration = now - task.startedAt;

  // Check timeout
  if (duration > escalationTriggers.timeout.threshold) {
    await escalateTask(task.id, {
      trigger: 'timeout',
      action: escalationTriggers.timeout.action,
      priority: escalationTriggers.timeout.priority
    });
  }

  // Check failure count
  const failureCount = task.events.filter(e => e.type === 'error').length;
  if (failureCount >= escalationTriggers.ci_failure.retries) {
    await escalateTask(task.id, {
      trigger: 'retry_limit_exceeded',
      action: escalationTriggers.ci_failure.action,
      priority: escalationTriggers.ci_failure.priority
    });
  }
}
```

### Manual Intervention Queue

When escalation is triggered:
1. Task moved to "Needs Review" column
2. Assigned to on-call engineer or code owner
3. Notification sent to Slack/Email
4. SLA timer starts (e.g., 1 hour response time)
5. Engineer reviews logs and makes decision
6. Task either proceeds or needs redesign

---

## Summary

Centro de Control provides:
- ✅ Fully automated issue-to-deployment workflow
- ✅ Real-time monitoring and dashboards
- ✅ Intelligent retry and error recovery
- ✅ Seamless multi-agent coordination
- ✅ Graceful degradation with manual escalation
- ✅ Comprehensive metrics and reporting

**Status**: Implementation Ready  
**Last Updated**: 2026-11-12
