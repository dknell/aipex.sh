#!/bin/bash

# Enterprise AI Coding Workflow Setup Script v2.1
# Refactored modular version - non-prescriptive, organized, and DRY

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://raw.githubusercontent.com/dknell/aipex.sh/refs/heads/main"
TEMPLATES_BASE_URL="$REPO_URL/templates"

# Header
echo -e "${CYAN}🚀 Enterprise AI Coding Workflow Setup v2.1${NC}"
echo -e "${BLUE}Non-prescriptive, organized, and Claude CLI integrated${NC}"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: This script must be run in a git repository${NC}"
    exit 1
fi

# Utility functions
download_file() {
    local url=$1
    local output=$2
    local description=$3
    
    echo -e "${BLUE}Downloading $description...${NC}"
    if command -v curl &> /dev/null; then
        curl -sSL "$url" -o "$output"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output"
    else
        echo -e "${RED}Error: Neither curl nor wget found${NC}"
        exit 1
    fi
}

download_template() {
    local template_path=$1
    local target_path=$2
    
    download_file "$TEMPLATES_BASE_URL/$template_path" "$target_path" "$template_path"
}

create_directory_structure() {
    echo -e "${BLUE}Creating directory structure...${NC}"
    
    # Core directories
    mkdir -p .claude/{commands,agents,hooks}
    mkdir -p .aipex/{config,PRPs/{templates,generated},examples/{typescript,testing,security,components}}
    mkdir -p .aipex/templates/{prompts,configs,examples,scripts,agents}
    
    echo "✓ Directory structure created"
}

download_core_components() {
    echo -e "${BLUE}Downloading modular components...${NC}"
    
    # Download utility scripts
    download_template "scripts/tool-detection.sh" ".aipex/templates/scripts/tool-detection.sh"
    download_template "scripts/setup-configs.sh" ".aipex/templates/scripts/setup-configs.sh"
    chmod +x .aipex/templates/scripts/*.sh
    
    # Download Claude context template
    download_template "configs/aipex-context.md" ".aipex/templates/configs/aipex-context.md"
    
    # Download INITIAL.md template
    download_file "$REPO_URL/INITIAL.md.template" "INITIAL.md.template" "INITIAL.md template"
    
    echo "✓ Core components downloaded"
}

download_prompts() {
    echo -e "${BLUE}Downloading Claude prompts...${NC}"
    
    local prompts=(
        "generate-prp"
        "execute-prp" 
        "validate-ts"
        "validate-lint"
        "run-tests"
        "security-check"
        "qa-review"
    )
    
    for prompt in "${prompts[@]}"; do
        download_template "prompts/$prompt.md" ".aipex/templates/prompts/$prompt.md"
    done
    
    echo "✓ Prompts downloaded"
}

download_templates() {
    echo -e "${BLUE}Downloading templates...${NC}"
    
    # Download template files
    download_template "configs/security-rules.json" ".aipex/templates/configs/security-rules.json"
    download_template "examples/component-pattern.tsx" ".aipex/templates/examples/component-pattern.tsx"
    download_template "prp-enterprise-base.md" ".aipex/templates/prp-enterprise-base.md"
    
    # Download agent definitions
    local agents=("developer-agent" "qa-agent" "security-agent")
    for agent in "${agents[@]}"; do
        download_template "agents/$agent.md" ".aipex/templates/agents/$agent.md"
    done
    
    echo "✓ Templates downloaded"
}

detect_and_show_tools() {
    # Source tool detection functions
    source .aipex/templates/scripts/tool-detection.sh
    source .aipex/templates/scripts/setup-configs.sh
    
    # Show detected tools
    show_tool_status
    
    # Display interactive confirmation
    show_planned_actions
    
    # Get user confirmation
    echo ""
    echo -e "${CYAN}Continue with setup? [Y/n]:${NC} \c"
    read -r response
    if [[ "$response" =~ ^[Nn]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
}

show_planned_actions() {
    echo ""
    echo -e "${CYAN}📋 PLANNED ACTIONS:${NC}"
    echo "┌─────────────────────────────────────────┐"
    echo "│ DIRECTORY STRUCTURE:                    │"
    echo "│ ✓ Create .claude/ commands & agents     │"
    echo "│ ✓ Create .aipex/ organized container    │"
    echo "│ ✓ Setup .aipex/templates/ for modularity│"
    echo "│                                         │"
    echo "│ CLAUDE COMMANDS:                        │"
    echo "│ ✓ Install 7 enhanced Claude commands    │"
    echo "│ ✓ Setup multi-agent validation system   │"
    echo "│                                         │"
    echo "│ FEATURES:                               │"
    echo "│ ✓ Ticket-based PRP naming              │"
    echo "│ ✓ Security configurations              │"
    echo "│ ✓ Example patterns                     │"
    echo "│ ✓ Package.json scripts (if available)  │"
    echo "└─────────────────────────────────────────┘"
}

show_tool_status() {
    local tool_name=$1
    local is_available=$2
    
    if [ "$is_available" = "true" ]; then
        echo "│ ✓ $tool_name detected (will use existing) │"
    else
        echo "│ ⚠ $tool_name not detected                │"
    fi
}

install_claude_commands() {
    echo -e "${BLUE}Installing Claude Code commands...${NC}"
    
    # Copy prompt templates to Claude commands
    local prompts=(
        "generate-prp"
        "execute-prp"
        "validate-ts"
        "validate-lint"
        "run-tests"
        "security-check"
        "qa-review"
    )
    
    for prompt in "${prompts[@]}"; do
        cp ".aipex/templates/prompts/$prompt.md" ".claude/commands/$prompt.md"
    done
    
    echo "✓ Installed 7 enhanced Claude commands"
}

create_agent_definitions() {
    echo -e "${BLUE}Creating agent definitions...${NC}"
    
    local agents=("developer-agent" "qa-agent" "security-agent")
    for agent in "${agents[@]}"; do
        cp ".aipex/templates/agents/$agent.md" ".claude/agents/$agent.md"
    done
    
    echo "✓ Agent definitions created"
}

setup_aipex_structure() {
    echo -e "${BLUE}Setting up .aipex structure...${NC}"
    
    # Run the setup script from templates
    bash .aipex/templates/scripts/setup-configs.sh
    
    # Copy security configuration
    cp ".aipex/templates/configs/security-rules.json" ".aipex/config/security-rules.json"
    
    # Copy example patterns
    cp ".aipex/templates/examples/component-pattern.tsx" ".aipex/examples/typescript/component-pattern.tsx"
    
    # Copy PRP template
    cp ".aipex/templates/prp-enterprise-base.md" ".aipex/PRPs/templates/prp-enterprise-base.md"
    
    echo "✓ .aipex structure configured"
}

setup_claude_integration() {
    echo -e "${BLUE}Setting up Claude CLI integration...${NC}"
    
    if command -v claude &> /dev/null; then
        echo "🤖 Claude CLI detected - setting up project context..."
        
        if [ ! -f "CLAUDE.md" ]; then
            echo "Creating CLAUDE.md with enterprise AI workflow context..."
            claude init --non-interactive 2>/dev/null || echo "✓ Using alternative CLAUDE.md setup"
            
            # Add our context
            echo "" >> CLAUDE.md
            echo "# Enterprise AI Workflow Context" >> CLAUDE.md
            echo "" >> CLAUDE.md
            cat .aipex/templates/configs/aipex-context.md >> CLAUDE.md
            echo "✓ Added enterprise AI workflow context to CLAUDE.md"
        else
            echo "CLAUDE.md exists - appending enterprise AI workflow context..."
            echo "" >> CLAUDE.md
            echo "# Enterprise AI Workflow Context" >> CLAUDE.md
            echo "" >> CLAUDE.md
            cat .aipex/templates/configs/aipex-context.md >> CLAUDE.md
            echo "✓ Enterprise AI workflow context added to existing CLAUDE.md"
        fi
    else
        echo "⚠ Claude CLI not found - skipping CLAUDE.md generation"
        echo "💡 Install Claude CLI: https://docs.anthropic.com/en/docs/claude-code"
    fi
}

cleanup_and_summary() {
    echo -e "${BLUE}Finalizing setup...${NC}"
    
    # Final summary
    echo ""
    echo -e "${GREEN}✅ Enterprise AI Workflow Setup Complete!${NC}"
    echo ""
    echo -e "${CYAN}📋 WHAT WAS INSTALLED:${NC}"
    echo "• Enhanced Claude Code commands with multi-agent validation"
    echo "• Smart tool detection (adapts to your existing setup)"
    echo "• Organized .aipex/ structure for all generated content"
    echo "• Ticket-based PRP naming for project management"
    
    if command -v claude &> /dev/null; then
        echo "• CLAUDE.md with enterprise AI workflow context"
    fi
    
    echo "• Security configurations and example patterns"
    echo "• Package.json scripts for validation workflow"
    echo ""
    
    echo -e "${CYAN}🚀 GETTING STARTED:${NC}"
    echo "1. Customize your ticket: ${YELLOW}cp INITIAL.md.template INITIAL.md${NC}"
    echo "2. Edit INITIAL.md with your ticket ID and feature details"
    echo "3. Generate PRP: ${YELLOW}/generate-prp INITIAL.md${NC}"
    echo "4. Execute with validation: ${YELLOW}/execute-prp .aipex/PRPs/generated/{TICKET_ID}.md${NC}"
    echo ""
    
    echo -e "${CYAN}🛠️ MANUAL VALIDATION COMMANDS:${NC}"
    echo "• ${YELLOW}/validate-ts${NC} - TypeScript compilation and type checking"
    echo "• ${YELLOW}/validate-lint${NC} - ESLint validation with auto-fixing"
    echo "• ${YELLOW}/run-tests${NC} - Full test suite with coverage"
    echo "• ${YELLOW}/security-check${NC} - Security scanning and validation"
    echo "• ${YELLOW}/qa-review${NC} - QA agent comprehensive review"
    echo ""
    
    echo -e "${GREEN}Ready for enterprise-grade AI-assisted development! 🎯${NC}"
    echo -e "${CYAN}Note: This setup adapts to your existing tool configurations${NC}"
}

# Main execution flow
main() {
    create_directory_structure
    download_core_components
    download_prompts
    download_templates
    detect_and_show_tools
    
    echo ""
    echo -e "${GREEN}🚀 Starting enhanced setup...${NC}"
    
    install_claude_commands
    create_agent_definitions
    setup_aipex_structure
    setup_claude_integration
    
    # Package scripts are handled by setup-configs.sh
    
    cleanup_and_summary
}

# Run main function
main