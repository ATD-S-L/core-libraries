#!/bin/bash
#
# Trigger Agent for Local Testing
# Usage: ./scripts/trigger-agent.sh --issue 1 --agent backend
#
# This script uses the GitHub CLI (gh) to manually trigger the agent dispatcher
# for a specific issue when automatic webhook triggering has delays or issues.
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ISSUE_NUMBER=""
AGENT_TYPE=""
REPOSITORY=""

# Function to print colored output
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to print usage
usage() {
    cat << EOF
Usage: ./scripts/trigger-agent.sh [OPTIONS]

OPTIONS:
    --issue ISSUE_NUMBER      Issue number to dispatch (required)
    --agent AGENT_TYPE        Agent type: backend|frontend|firmware|library (required)
    --repo REPOSITORY         Repository (optional, auto-detected from git)
    --help                    Show this help message

EXAMPLES:
    # Trigger backend agent for issue #1
    ./scripts/trigger-agent.sh --issue 1 --agent backend
    
    # Trigger frontend agent for issue #5
    ./scripts/trigger-agent.sh --issue 5 --agent frontend

EOF
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --issue)
            ISSUE_NUMBER="$2"
            shift 2
            ;;
        --agent)
            AGENT_TYPE="$2"
            shift 2
            ;;
        --repo)
            REPOSITORY="$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [ -z "$ISSUE_NUMBER" ] || [ -z "$AGENT_TYPE" ]; then
    log_error "Missing required arguments"
    usage
fi

# Validate agent type
case $AGENT_TYPE in
    backend|frontend|firmware|library)
        ;;
    *)
        log_error "Invalid agent type: $AGENT_TYPE"
        log_info "Valid types: backend, frontend, firmware, library"
        exit 1
        ;;
esac

# Auto-detect repository if not specified
if [ -z "$REPOSITORY" ]; then
    if ! REPOSITORY=$(gh repo view --json nameWithOwner -q); then
        log_error "Could not detect repository. Please run from repo root or use --repo"
        exit 1
    fi
fi

log_info "Agent Trigger Script v1.0"
log_info ""
log_info "Configuration:"
log_info "  Repository: $REPOSITORY"
log_info "  Issue: #$ISSUE_NUMBER"
log_info "  Agent: $AGENT_TYPE"
log_info ""

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    log_error "GitHub CLI (gh) is not installed"
    log_info "Install from: https://cli.github.com"
    exit 1
fi

log_success "GitHub CLI found"

# Verify issue exists
log_info "Verifying issue #$ISSUE_NUMBER exists..."
if ! ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --repo "$REPOSITORY" --json title,body,labels 2>/dev/null); then
    log_error "Issue #$ISSUE_NUMBER not found in $REPOSITORY"
    exit 1
fi

ISSUE_TITLE=$(echo "$ISSUE_DATA" | jq -r '.title')
log_success "Found issue: $ISSUE_TITLE"

# Trigger manual dispatch workflow
log_info ""
log_info "Triggering manual dispatch workflow..."
log_info "  (This sends the issue to the $AGENT_TYPE agent)"

if gh workflow run agent-dispatch-manual.yml \
    -F issue_number="$ISSUE_NUMBER" \
    -F agent_type="$AGENT_TYPE" \
    --repo "$REPOSITORY" 2>/dev/null; then
    
    log_success "Workflow triggered successfully!"
    log_info ""
    log_info "What happens next:"
    log_info "  1. Workflow runs in GitHub Actions"
    log_info "  2. $AGENT_TYPE agent is dispatched with issue context"
    log_info "  3. Agent creates a feature branch"
    log_info "  4. Agent implements the solution"
    log_info "  5. Agent opens a PR for review"
    log_info ""
    log_info "Monitor progress:"
    log_info "  • GitHub Actions: https://github.com/$REPOSITORY/actions"
    log_info "  • Issue: https://github.com/$REPOSITORY/issues/$ISSUE_NUMBER"
    log_info "  • Pull Requests: https://github.com/$REPOSITORY/pulls"
    
else
    log_error "Failed to trigger workflow"
    log_warning "Make sure:"
    log_warning "  1. You have write access to the repository"
    log_warning "  2. agent-dispatch-manual.yml workflow exists"
    log_warning "  3. GitHub CLI is authenticated: 'gh auth status'"
    exit 1
fi

log_info ""
log_success "Agent trigger complete! Check the Actions tab for progress."
