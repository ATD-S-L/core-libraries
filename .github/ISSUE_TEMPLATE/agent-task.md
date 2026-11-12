---
name: Agent Implementation Task
description: Create a feature or fix for the specialized agent team
labels: ['agent-task']
---

## 📋 Description

Provide a clear, detailed description of what needs to be implemented.

### What should be done?
[Describe the feature, fix, or improvement]

**Examples:**
- Implement user authentication with OAuth 2.0
- Create a responsive card component with animations
- Add WiFi provisioning flow for ESP32 devices
- Build a shared utility library for date formatting

### Why is this needed?
[Explain the business value or user benefit]

**Examples:**
- Improve security by implementing industry-standard auth
- Enhance UX with modern, accessible components
- Enable wireless configuration without USB
- Reduce code duplication across 3+ services

## 🎯 Acceptance Criteria

- [ ] Core functionality implemented and working
- [ ] All tests passing with >80% coverage
- [ ] Code follows repository style guide
- [ ] Documentation updated (README, inline comments where needed)
- [ ] No breaking changes (or documented with migration guide if intentional)
- [ ] Performance meets requirements (if applicable)
- [ ] Security review completed (if handling sensitive data)

**Definition of Done:**
The implementation is complete when all checkboxes above are ticked AND a PR is automatically created and merged.

## 🏗️ Component & Tech Stack

**Select the primary component:**
- [ ] **Backend** (APIs, database, business logic, business rules, integration)
- [ ] **Frontend** (UI/UX, components, state management, styling)
- [ ] **Firmware** (ESP32 drivers, HAL, bootloader, hardware integration)
- [ ] **Library** (Shared utilities, multi-language, core algorithms, helpers)

**Technology notes** (optional):
[Specify frameworks, libraries, languages, APIs, or technical constraints]

**Examples:**
- Backend: Node.js/Express, PostgreSQL, REST API design
- Frontend: React, TypeScript, Tailwind CSS, React Query
- Firmware: Arduino SDK, FreeRTOS, I2C/UART protocols
- Library: Python 3.8+, TypeScript, cross-platform compatibility

## 📝 Implementation Notes

### Scope
[Define what's included and what's explicitly excluded]

### Dependencies
- [ ] Requires other issues: [#123, #456] (link related issues)
- [ ] Depends on external services: [List API, database, third-party service]
- [ ] Database migrations needed: [ ] Yes [ ] No
- [ ] Configuration changes: [ ] Yes [ ] No
- [ ] Breaking changes: [ ] Yes [ ] No

**Dependency Examples:**
- Requires: User auth system (#450), PostgreSQL migration (#451)
- External: Stripe API v3, AWS S3, SendGrid email
- Database: New `payments` table with migration script

### Performance Considerations
[Any performance requirements, SLAs, or benchmarks?]

**Examples:**
- API response time must be <100ms
- Handle 1000 concurrent connections
- Memory footprint <50MB on ESP32
- Build time must not exceed 2 minutes

### Security Considerations
[Any security implications? Authentication, authorization, data handling, compliance?]

**Examples:**
- Uses OAuth 2.0 for secure authentication
- All passwords hashed with bcrypt
- Data encrypted at rest using AES-256
- Complies with GDPR data retention policies
- Validates all user input to prevent SQL injection

## 🔗 Related Issues & PRs

- Related issue: [link]
- Related PR: [link]
- Blocks issue: [link]
- Blocked by issue: [link]

## 📊 Effort Estimate

The specialized agent will provide a more precise estimate, but initial guidance:
- [ ] Small (1-2 hours)
- [ ] Medium (2-4 hours)
- [ ] Large (4-8 hours)
- [ ] Extra Large (8+ hours)

## ✨ Additional Context

[Any attachments, mockups, design documents, or additional context that would help?]

---

**Agent Documentation & Resources:**
- 📚 [Agent Team Architecture](../../AGENTS_TEAM_ARCHITECTURE.md)
- 🚀 [Agent Infrastructure Guide](../../AGENT_INFRASTRUCTURE_README.md)
- 🤖 [Agent Orchestration Details](../../AGENTS_ORCHESTRATION.md)
- ⚙️ [Automation Flows](../../CONTROL_CENTER_AUTOMATION_FLOWS.md)

**How this works:**
1. Create this issue with the appropriate label (`backend`/`frontend`/`firmware`/`library`)
2. Centro de Control automatically routes it to the specialized agent
3. The agent analyzes, plans, implements, tests, and opens a PR
4. CI/CD checks run automatically
5. PR auto-merges when all checks pass
6. Issue closes automatically with completion summary

**Best Practices for Agent Tasks:**
- Be as specific as possible about requirements
- Include acceptance criteria, not just features
- Link related issues and PRs
- Mention any constraints (performance, security, compatibility)
- Provide examples or mockups if applicable
- Comment with updates if requirements change

**Questions?** Comment on this issue and the agent will respond immediately.
