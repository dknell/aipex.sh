#!/bin/bash

# Setup Configuration Script
# Creates .aipex directory structure and package.json scripts

setup_aipex_structure() {
    echo "📁 Creating .aipex directory structure..."
    mkdir -p .aipex/{templates,PRPs/{generated,active},examples,agents,scripts,configs}
    
    echo "✅ .aipex structure created:"
    echo "   - .aipex/templates/    (Downloaded templates)"
    echo "   - .aipex/PRPs/         (Project Requirements & Plans)"
    echo "   - .aipex/examples/     (Code examples and patterns)"
    echo "   - .aipex/agents/       (Agent definitions)"
    echo "   - .aipex/scripts/      (Utility scripts)"
    echo "   - .aipex/configs/      (Configuration templates)"
}

add_package_scripts() {
    local package_json="package.json"
    
    if [ ! -f "$package_json" ]; then
        echo "⚠️  No package.json found - creating basic structure"
        cat > "$package_json" << 'EOF'
{
  "name": "aipex-project",
  "version": "1.0.0",
  "scripts": {
    "aipex:validate": "echo 'Running AIPEX validation...'",
    "aipex:test": "echo 'Running AIPEX tests...'",
    "aipex:security": "echo 'Running security scan...'"
  }
}
EOF
        echo "✅ Created basic package.json with AIPEX scripts"
        return
    fi
    
    # Check if AIPEX scripts already exist
    if grep -q "aipex:" "$package_json"; then
        echo "ℹ️  AIPEX scripts already exist in package.json"
        return
    fi
    
    # Add AIPEX scripts to existing package.json
    echo "📝 Adding AIPEX scripts to package.json..."
    
    # Create a temporary file with the updated package.json
    python3 -c "
import json
import sys

try:
    with open('$package_json', 'r') as f:
        data = json.load(f)
    
    if 'scripts' not in data:
        data['scripts'] = {}
    
    # Add AIPEX scripts
    aipex_scripts = {
        'aipex:validate': 'echo \"Running AIPEX validation...\"',
        'aipex:test': 'echo \"Running AIPEX tests...\"',
        'aipex:security': 'echo \"Running security scan...\"'
    }
    
    for key, value in aipex_scripts.items():
        if key not in data['scripts']:
            data['scripts'][key] = value
    
    with open('$package_json', 'w') as f:
        json.dump(data, f, indent=2)
    
    print('✅ Added AIPEX scripts to package.json')
    
except Exception as e:
    print(f'❌ Error updating package.json: {e}')
    sys.exit(1)
"
}

create_gitignore_entries() {
    local gitignore_file=".gitignore"
    
    # AIPEX-specific entries to add
    local aipex_entries="
# AIPEX - AI Development Workflow
.aipex/PRPs/active/
.aipex/logs/
.aipex/temp/
"
    
    if [ ! -f "$gitignore_file" ]; then
        echo "📝 Creating .gitignore with AIPEX entries..."
        echo "$aipex_entries" > "$gitignore_file"
    else
        if ! grep -q ".aipex" "$gitignore_file"; then
            echo "📝 Adding AIPEX entries to existing .gitignore..."
            echo "$aipex_entries" >> "$gitignore_file"
        else
            echo "ℹ️  AIPEX entries already exist in .gitignore"
        fi
    fi
}

main() {
    echo "🚀 Setting up AIPEX project structure..."
    
    setup_aipex_structure
    add_package_scripts
    create_gitignore_entries
    
    echo ""
    echo "✅ AIPEX setup complete!"
    echo ""
    echo "Next steps:"
    echo "1. Run: aipex /generate-prp"
    echo "2. Fill out your PRP in .aipex/PRPs/generated/"
    echo "3. Execute: aipex /execute-prp .aipex/PRPs/generated/your-prp.md"
}

# Run setup if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi