#!/bin/bash

# Tool Detection Script
# Detects existing development tools and configurations

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
    if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f "eslint.config.js" ]; then
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

show_tool_status() {
    echo "🔍 Detected Development Environment:"
    echo "Package Manager: $(detect_package_manager)"
    echo "TypeScript: $(detect_typescript)"
    echo "Framework: $(detect_framework)"
    echo "Testing: $(detect_testing_framework)"
    echo "Linting: $(detect_linting)"
    echo "Formatting: $(detect_formatting)"
    echo ""
}

# Export functions for use in other scripts
export -f detect_package_manager
export -f detect_typescript
export -f detect_testing_framework
export -f detect_linting
export -f detect_formatting
export -f detect_framework
export -f show_tool_status