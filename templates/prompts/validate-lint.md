---
name: "ESLint Validation" 
description: "Comprehensive ESLint validation with auto-fixing"
---

# ESLint Validation Command

Run comprehensive ESLint validation:

1. **Lint Check**: `eslint src/ --ext .ts,.tsx`
2. **Auto-fix**: `eslint src/ --ext .ts,.tsx --fix`
3. **Style Check**: Verify code formatting consistency
4. **Custom Rules**: Check enterprise-specific rules

Apply auto-fixes for:
- Code formatting issues
- Import ordering
- Unused variables
- Missing semicolons

Report any non-auto-fixable issues with specific guidance.

Success criteria: Zero ESLint errors or warnings.