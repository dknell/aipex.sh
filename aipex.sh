#!/bin/bash

# Enterprise AI Coding Workflow Setup Script v2.1
# Refactored modular version - non-prescriptive, organized, and DRY

set -e

# Parse command line arguments
DRY_RUN=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--dry-run] [--help]"
            echo "  --dry-run    Show what would be done without making changes"
            echo "  --help       Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Colors for output - check if output is a terminal
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m' # No Color
else
    # No colors for non-terminal output
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    NC=''
fi

# Configuration
REPO_URL="https://raw.githubusercontent.com/dknell/aipex.sh/refs/heads/main"
TEMPLATES_BASE_URL="$REPO_URL/templates"

# Project evaluation variables
PROJECT_PACKAGE_MANAGER=""
PROJECT_TYPESCRIPT=""
PROJECT_FRAMEWORK=""
PROJECT_TESTING=""
PROJECT_LINTING=""
PROJECT_FORMATTING=""

# Header
printf "${CYAN}🚀 Enterprise AI Coding Workflow Setup v2.1${NC}\n"
if [ "$DRY_RUN" = true ]; then
    printf "${YELLOW}📋 DRY RUN MODE - No files will be created${NC}\n"
fi
printf "${BLUE}Non-prescriptive, organized, and Claude CLI integrated${NC}\n"
printf "\n"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    printf "${RED}Error: This script must be run in a git repository${NC}\n"
    exit 1
fi

# Utility functions
download_file() {
    local url=$1
    local output=$2
    local description=$3
    
    if [ "$DRY_RUN" = true ]; then
        printf "${BLUE}Downloading %s... ${YELLOW}(SKIPPED - dry-run)${NC}\n" "$description"
        return 0
    fi
    
    printf "${BLUE}Downloading %s...${NC}\n" "$description"
    if command -v curl &> /dev/null; then
        curl -sSL "$url" -o "$output"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output"
    else
        printf "${RED}Error: Neither curl nor wget found${NC}\n"
        exit 1
    fi
}

download_template() {
    local template_path=$1
    local target_path=$2
    
    download_file "$TEMPLATES_BASE_URL/$template_path" "$target_path" "$template_path"
}

create_directory_structure() {
    printf "${BLUE}Creating directory structure...${NC}\n"
    
    if [ "$DRY_RUN" = true ]; then
        printf "✓ Directory structure created ${YELLOW}(SKIPPED - dry-run)${NC}\n"
        printf "  Would create: .claude/{commands,agents,hooks}\n"
        printf "  Would create: .aipex/{config,PRPs/{templates,generated},examples/{typescript,testing,security,components}}\n"
        printf "  Would create: .aipex/templates/{prompts,configs,examples,scripts,agents}\n"
        return 0
    fi
    
    # Core directories
    mkdir -p .claude/{commands,agents,hooks}
    mkdir -p .aipex/{config,PRPs/{templates,generated},examples/{typescript,testing,security,components}}
    mkdir -p .aipex/templates/{prompts,configs,examples,scripts,agents}
    
    printf "✓ Directory structure created\n"
}

download_core_components() {
    printf "${BLUE}Downloading modular components...${NC}\n"
    
    # Download utility scripts
    download_template "scripts/tool-detection.sh" ".aipex/templates/scripts/tool-detection.sh"
    download_template "scripts/setup-configs.sh" ".aipex/templates/scripts/setup-configs.sh"
    
    if [ "$DRY_RUN" = true ]; then
        printf "${BLUE}Making scripts executable... ${YELLOW}(SKIPPED - dry-run)${NC}\n"
    else
        chmod +x .aipex/templates/scripts/*.sh
    fi
    
    # Download Claude context template
    download_template "configs/aipex-context.md" ".aipex/templates/configs/aipex-context.md"
    
    # Download INITIAL.md template
    download_file "$REPO_URL/INITIAL.md.template" "INITIAL.md.template" "INITIAL.md template"
    
    if [ "$DRY_RUN" = true ]; then
        printf "✓ Core components downloaded ${YELLOW}(SKIPPED - dry-run)${NC}\n"
    else
        printf "✓ Core components downloaded\n"
    fi
}

download_prompts() {
    printf "${BLUE}Downloading Claude prompts...${NC}\n"
    
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
    
    if [ "$DRY_RUN" = true ]; then
        printf "✓ Prompts downloaded ${YELLOW}(SKIPPED - dry-run)${NC}\n"
    else
        printf "✓ Prompts downloaded\n"
    fi
}

download_templates() {
    printf "${BLUE}Downloading templates...${NC}\n"
    
    # Download template files
    download_template "configs/security-rules.json" ".aipex/templates/configs/security-rules.json"
    download_template "examples/component-pattern.tsx" ".aipex/templates/examples/component-pattern.tsx"
    download_template "prp-enterprise-base.md" ".aipex/templates/prp-enterprise-base.md"
    
    # Download agent definitions
    local agents=("developer-agent" "qa-agent" "security-agent")
    for agent in "${agents[@]}"; do
        download_template "agents/$agent.md" ".aipex/templates/agents/$agent.md"
    done
    
    if [ "$DRY_RUN" = true ]; then
        printf "✓ Templates downloaded ${YELLOW}(SKIPPED - dry-run)${NC}\n"
    else
        printf "✓ Templates downloaded\n"
    fi
}

get_user_confirmation() {
    # Display interactive confirmation
    show_planned_actions
    
    # Get user confirmation - redirect to /dev/tty for piped input
    printf "\n"
    if [ "$DRY_RUN" = true ]; then
        printf "${CYAN}Continue with dry-run? [Y/n]:${NC} "
    else
        printf "${CYAN}Continue with setup? [Y/n]:${NC} "
    fi
    
    # Handle piped input by redirecting to /dev/tty if available
    if [ -t 0 ]; then
        read -r response
    else
        # Try to read from /dev/tty for piped input
        if [ -c /dev/tty ] && read -r response < /dev/tty 2>/dev/null; then
            : # Successfully read from /dev/tty
        else
            # Fallback: read from stdin (for piped input like echo "Y" | script)
            read -r response
        fi
    fi
    
    if [[ "$response" =~ ^[Nn]$ ]]; then
        printf "Setup cancelled.\n"
        exit 0
    fi
}

detect_and_show_tools() {
    if [ "$DRY_RUN" = false ]; then
        # Source tool detection functions
        source .aipex/templates/scripts/tool-detection.sh
        source .aipex/templates/scripts/setup-configs.sh
        
        # Show detected tools (this runs after files are downloaded)
        printf "${BLUE}🔍 Final tool detection and configuration...${NC}\n"
        printf "Package Manager: $PROJECT_PACKAGE_MANAGER\n"
        printf "TypeScript: $PROJECT_TYPESCRIPT\n"
        printf "Framework: $PROJECT_FRAMEWORK\n"
        printf "Testing: $PROJECT_TESTING\n"
        printf "Linting: $PROJECT_LINTING\n"
        printf "Formatting: $PROJECT_FORMATTING\n"
    else
        printf "${BLUE}🔍 Tool detection: ${YELLOW}(SKIPPED - dry-run)${NC}\n"
    fi
}

show_planned_actions() {
    printf "\n"
    printf "${CYAN}📋 PLANNED ACTIONS:${NC}\n"
    printf "+----------------------------------------------------+\n"
    printf "| %-50s |\n" "DIRECTORY STRUCTURE:"
    printf "| %-50s |\n" "[x] Create .claude/ commands & agents"
    printf "| %-50s |\n" "[x] Create .aipex/ organized container"
    printf "| %-50s |\n" "[x] Setup .aipex/templates/ for modularity"
    printf "| %-50s |\n" ""
    printf "| %-50s |\n" "CLAUDE COMMANDS:"
    printf "| %-50s |\n" "[x] Install 7 enhanced Claude commands"
    printf "| %-50s |\n" "[x] Setup multi-agent validation system"
    printf "| %-50s |\n" ""
    printf "| %-50s |\n" "FEATURES:"
    printf "| %-50s |\n" "[x] Ticket-based PRP naming"
    printf "| %-50s |\n" "[x] Security configurations"
    printf "| %-50s |\n" "[x] Example patterns"
    if [ "$PROJECT_PACKAGE_MANAGER" != "none" ]; then
        printf "| %-50s |\n" "[x] Package.json scripts integration"
    else
        printf "| %-50s |\n" "[-] No package.json detected"
    fi
    printf "+----------------------------------------------------+\n"
}

# Project evaluation functions (extracted from tool-detection.sh)
detect_package_manager() {
    if [ -f "package-lock.json" ]; then
        echo "npm"
    elif [ -f "yarn.lock" ]; then
        echo "yarn"
    elif [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "bun.lockb" ]; then
        echo "bun"
    else
        echo "npm"  # default
    fi
}

detect_typescript() {
    if [ -f "tsconfig.json" ] || [ -f "src/tsconfig.json" ]; then
        echo "true"
    else
        echo "false"
    fi
}

detect_testing_framework() {
    local package_json="package.json"
    if [ -f "$package_json" ]; then
        if grep -q "jest" "$package_json"; then
            echo "jest"
        elif grep -q "vitest" "$package_json"; then
            echo "vitest"
        elif grep -q "mocha" "$package_json"; then
            echo "mocha"
        elif grep -q "ava" "$package_json"; then
            echo "ava"
        else
            echo "none"
        fi
    else
        echo "none"
    fi
}

detect_linting() {
    if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.cjs" ] || [ -f "eslint.config.mjs" ]; then
        echo "eslint"
    elif [ -f ".jshintrc" ]; then
        echo "jshint"
    else
        echo "none"
    fi
}

detect_formatting() {
    if [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ] || [ -f "prettier.config.js" ]; then
        echo "prettier"
    else
        echo "none"
    fi
}

detect_framework() {
    local package_json="package.json"
    if [ -f "$package_json" ]; then
        if grep -q "next" "$package_json"; then
            echo "nextjs"
        elif grep -q "react" "$package_json"; then
            echo "react"
        elif grep -q "vue" "$package_json"; then
            echo "vue"
        elif grep -q "angular" "$package_json"; then
            echo "angular"
        elif grep -q "svelte" "$package_json"; then
            echo "svelte"
        else
            echo "none"
        fi
    else
        echo "none"
    fi
}

evaluate_project() {
    printf "${BLUE}🔍 Evaluating project environment...${NC}\n"
    
    # Detect all tools and store in global variables
    PROJECT_PACKAGE_MANAGER=$(detect_package_manager)
    PROJECT_TYPESCRIPT=$(detect_typescript)
    PROJECT_FRAMEWORK=$(detect_framework)
    PROJECT_TESTING=$(detect_testing_framework)
    PROJECT_LINTING=$(detect_linting)
    PROJECT_FORMATTING=$(detect_formatting)
    
    printf "${BLUE}📋 Project Analysis Complete${NC}\n"
    printf "Package Manager: $PROJECT_PACKAGE_MANAGER\n"
    printf "TypeScript: $PROJECT_TYPESCRIPT\n"
    printf "Framework: $PROJECT_FRAMEWORK\n"
    printf "Testing: $PROJECT_TESTING\n"
    printf "Linting: $PROJECT_LINTING\n"
    printf "Formatting: $PROJECT_FORMATTING\n"
}

install_claude_commands() {
    printf "${BLUE}Installing Claude Code commands...${NC}\n"
    
    if [ "$DRY_RUN" = true ]; then
        printf "✓ Installed 7 enhanced Claude commands ${YELLOW}(SKIPPED - dry-run)${NC}\n"
        printf "  Would copy: .aipex/templates/prompts/*.md → .claude/commands/\n"
        return 0
    fi
    
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
    
    printf "✓ Installed 7 enhanced Claude commands\n"
}

create_agent_definitions() {
    printf "${BLUE}Creating agent definitions...${NC}\n"
    
    if [ "$DRY_RUN" = true ]; then
        printf "✓ Agent definitions created ${YELLOW}(SKIPPED - dry-run)${NC}\n"
        printf "  Would copy: .aipex/templates/agents/*.md → .claude/agents/\n"
        return 0
    fi
    
    local agents=("developer-agent" "qa-agent" "security-agent")
    for agent in "${agents[@]}"; do
        cp ".aipex/templates/agents/$agent.md" ".claude/agents/$agent.md"
    done
    
    printf "✓ Agent definitions created\n"
}

setup_aipex_structure() {
    printf "${BLUE}Setting up .aipex structure...${NC}\n"
    
    if [ "$DRY_RUN" = true ]; then
        printf "✓ .aipex structure configured ${YELLOW}(SKIPPED - dry-run)${NC}\n"
        printf "  Would run: setup-configs.sh script\n"
        printf "  Would copy: security-rules.json → .aipex/config/\n"
        printf "  Would copy: component-pattern.tsx → .aipex/examples/typescript/\n"
        printf "  Would copy: prp-enterprise-base.md → .aipex/PRPs/templates/\n"
        return 0
    fi
    
    # Run the setup script from templates
    bash .aipex/templates/scripts/setup-configs.sh
    
    # Copy security configuration
    cp ".aipex/templates/configs/security-rules.json" ".aipex/config/security-rules.json"
    
    # Copy example patterns
    cp ".aipex/templates/examples/component-pattern.tsx" ".aipex/examples/typescript/component-pattern.tsx"
    
    # Copy PRP template
    cp ".aipex/templates/prp-enterprise-base.md" ".aipex/PRPs/templates/prp-enterprise-base.md"
    
    printf "✓ .aipex structure configured\n"
}

setup_claude_integration() {
    printf "${BLUE}Setting up Claude CLI integration...${NC}\n"
    
    if [ "$DRY_RUN" = true ]; then
        if command -v claude &> /dev/null; then
            printf "🤖 Claude CLI detected - setting up project context... ${YELLOW}(SKIPPED - dry-run)${NC}\n"
            printf "  Would create/append: CLAUDE.md with enterprise AI workflow context\n"
        else
            printf "⚠ Claude CLI not found - skipping CLAUDE.md generation ${YELLOW}(dry-run)${NC}\n"
        fi
        return 0
    fi
    
    if command -v claude &> /dev/null; then
        printf "🤖 Claude CLI detected - setting up project context...\n"
        
        if [ ! -f "CLAUDE.md" ]; then
            printf "Creating CLAUDE.md with enterprise AI workflow context...\n"
            claude init --non-interactive 2>/dev/null || printf "✓ Using alternative CLAUDE.md setup\n"
            
            # Add our context
            printf "\n" >> CLAUDE.md
            printf "# Enterprise AI Workflow Context\n" >> CLAUDE.md
            printf "\n" >> CLAUDE.md
            cat .aipex/templates/configs/aipex-context.md >> CLAUDE.md
            printf "✓ Added enterprise AI workflow context to CLAUDE.md\n"
        else
            printf "CLAUDE.md exists - appending enterprise AI workflow context...\n"
            printf "\n" >> CLAUDE.md
            printf "# Enterprise AI Workflow Context\n" >> CLAUDE.md
            printf "\n" >> CLAUDE.md
            cat .aipex/templates/configs/aipex-context.md >> CLAUDE.md
            printf "✓ Enterprise AI workflow context added to existing CLAUDE.md\n"
        fi
    else
        printf "⚠ Claude CLI not found - skipping CLAUDE.md generation\n"
        printf "💡 Install Claude CLI: https://docs.anthropic.com/en/docs/claude-code\n"
    fi
}

cleanup_and_summary() {
    if [ "$DRY_RUN" = true ]; then
        printf "${BLUE}Dry-run complete - no files were created${NC}\n"
    else
        printf "${BLUE}Finalizing setup...${NC}\n"
    fi
    
    # Final summary
    printf "\n"
    if [ "$DRY_RUN" = true ]; then
        printf "${GREEN}✅ Enterprise AI Workflow Dry-run Complete!${NC}\n"
        printf "${CYAN}No files or directories were created. Run without --dry-run to install.${NC}\n"
    else
        printf "${GREEN}✅ Enterprise AI Workflow Setup Complete!${NC}\n"
    fi
    printf "\n"
    if [ "$DRY_RUN" = true ]; then
        printf "${CYAN}📋 WHAT WOULD BE INSTALLED:${NC}\n"
        printf "• Enhanced Claude Code commands with multi-agent validation ${YELLOW}(not created)${NC}\n"
        printf "• Smart tool detection (adapts to your existing setup) ${YELLOW}(not run)${NC}\n"
        printf "• Organized .aipex/ structure for all generated content ${YELLOW}(not created)${NC}\n"
        printf "• Ticket-based PRP naming for project management ${YELLOW}(not installed)${NC}\n"
    else
        printf "${CYAN}📋 WHAT WAS INSTALLED:${NC}\n"
        printf "• Enhanced Claude Code commands with multi-agent validation\n"
        printf "• Smart tool detection (adapts to your existing setup)\n"
        printf "• Organized .aipex/ structure for all generated content\n"
        printf "• Ticket-based PRP naming for project management\n"
    fi
    
    if command -v claude &> /dev/null; then
        if [ "$DRY_RUN" = true ]; then
            printf "• CLAUDE.md with enterprise AI workflow context ${YELLOW}(not created)${NC}\n"
        else
            printf "• CLAUDE.md with enterprise AI workflow context\n"
        fi
    fi
    
    if [ "$DRY_RUN" = true ]; then
        printf "• Security configurations and example patterns ${YELLOW}(not created)${NC}\n"
        printf "• Package.json scripts for validation workflow ${YELLOW}(not created)${NC}\n"
    else
        printf "• Security configurations and example patterns\n"
        printf "• Package.json scripts for validation workflow\n"
    fi
    printf "\n"
    
    if [ "$DRY_RUN" = false ]; then
        printf "${CYAN}🚀 GETTING STARTED:${NC}\n"
        printf "1. Customize your ticket: ${YELLOW}cp INITIAL.md.template INITIAL.md${NC}\n"
        printf "2. Edit INITIAL.md with your ticket ID and feature details\n"
        printf "3. Generate PRP: ${YELLOW}/generate-prp INITIAL.md${NC}\n"
        printf "4. Execute with validation: ${YELLOW}/execute-prp .aipex/PRPs/generated/{TICKET_ID}.md${NC}\n"
        printf "\n"
        
        printf "${CYAN}🛠️ MANUAL VALIDATION COMMANDS:${NC}\n"
        printf "• ${YELLOW}/validate-ts${NC} - TypeScript compilation and type checking\n"
        printf "• ${YELLOW}/validate-lint${NC} - ESLint validation with auto-fixing\n"
        printf "• ${YELLOW}/run-tests${NC} - Full test suite with coverage\n"
        printf "• ${YELLOW}/security-check${NC} - Security scanning and validation\n"
        printf "• ${YELLOW}/qa-review${NC} - QA agent comprehensive review\n"
        printf "\n"
    else
        printf "${CYAN}🚀 TO INSTALL FOR REAL:${NC}\n"
        printf "Run the same command without --dry-run:\n"
        printf "${YELLOW}curl -sSL https://raw.githubusercontent.com/dknell/aipex.sh/refs/heads/main/aipex.sh | bash${NC}\n"
        printf "\n"
    fi
    
    if [ "$DRY_RUN" = true ]; then
        printf "${GREEN}Dry-run completed! Run without --dry-run to install. 🎯${NC}\n"
    else
        printf "${GREEN}Ready for enterprise-grade AI-assisted development! 🎯${NC}\n"
        printf "${CYAN}Note: This setup adapts to your existing tool configurations${NC}\n"
    fi
}

# Main execution flow
main() {
    # Phase 1: Evaluate project (read-only, no file creation)
    evaluate_project
    get_user_confirmation
    
    # Phase 2: Setup (only runs after user confirmation)
    printf "\n"
    printf "${GREEN}🚀 Starting enhanced setup...${NC}\n"
    
    create_directory_structure
    download_core_components
    download_prompts
    download_templates
    detect_and_show_tools
    
    install_claude_commands
    create_agent_definitions
    setup_aipex_structure
    setup_claude_integration
    
    # Package scripts are handled by setup-configs.sh
    
    cleanup_and_summary
}

# Run main function
main