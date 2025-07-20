---
name: "Security Validation"
description: "Comprehensive security scanning and validation"
---

# Security Validation Command

Run comprehensive security validation:

1. **Dependency Scan**: `npm audit --audit-level=high`
2. **Vulnerability Check**: `snyk test` (if available)
3. **Code Security**: Scan for hardcoded secrets and security anti-patterns
4. **Authentication**: Validate authentication implementation
5. **Input Validation**: Check input sanitization patterns

## Security Checklist
- [ ] No high/critical vulnerabilities in dependencies
- [ ] No hardcoded secrets or API keys
- [ ] Proper input validation and sanitization
- [ ] Secure authentication implementation
- [ ] Proper error handling (no info leakage)
- [ ] HTTPS enforcement
- [ ] CORS configuration
- [ ] Rate limiting implementation

Report any security issues with severity levels.
Provide specific remediation steps for each issue.

Success criteria: Zero high/critical security issues.