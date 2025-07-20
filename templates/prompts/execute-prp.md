---
name: "Enhanced PRP Executor with Multi-Agent Validation"
description: "Execute PRPs with autonomous TypeScript, testing, and security validation"
---

# Enhanced PRP Execution with Multi-Agent System

## Instructions
You are the primary Developer Agent in a multi-agent validation system. Execute the PRP with continuous validation and autonomous quality assurance.

## Execution Process

### Phase 1: Environment Validation
1. Verify TypeScript configuration is correct
2. Check ESLint setup and rules
3. Validate test environment (Jest + Playwright)
4. Confirm security tooling is available

### Phase 2: Implementation Loop (Developer Agent)
1. **Code Implementation**
   - Write TypeScript code with strict typing
   - Follow existing patterns from examples/
   - Implement comprehensive error handling
   - Add JSDoc documentation

2. **Continuous Validation**
   - Run TypeScript compiler: `tsc --noEmit`
   - Run ESLint: `eslint src/ --ext .ts,.tsx --fix`
   - Execute unit tests: `npm test`
   - Check test coverage: `npm run test:coverage`

3. **Self-Correction Loop**
   - If TypeScript errors: Fix type issues and retry
   - If ESLint errors: Apply fixes and retry
   - If test failures: Debug and fix tests
   - If coverage below 80%: Add missing tests

### Phase 3: QA Review Loop (QA Agent)
1. **Code Quality Review**
   - Verify adherence to patterns
   - Check test quality and coverage
   - Validate error handling
   - Review documentation completeness

2. **Integration Testing**
   - Create Playwright integration tests
   - Test user workflows end-to-end
   - Validate performance benchmarks
   - Check accessibility compliance

3. **QA Validation Commands**
   ```bash
   npm run test:integration
   npm run test:e2e
   npm run test:performance
   npm run lint:check
   ```

### Phase 4: Security Review Loop (Security Agent)
1. **Security Validation**
   - Run dependency security scan: `npm audit`
   - Check for hardcoded secrets
   - Validate input sanitization
   - Review authentication/authorization

2. **Security Commands**
   ```bash
   npm audit --audit-level=high
   npm run security:scan
   npm run security:lint
   ```

### Phase 5: Final Validation
- All tests passing
- TypeScript compilation clean
- ESLint 100% compliant
- Security scan clean
- Performance benchmarks met
- Documentation complete

## Autonomous Operation Rules
- Maximum 5 fix iterations per validation type
- Auto-fix TypeScript and ESLint issues when possible
- Never proceed with critical security issues
- Escalate only on unresolvable conflicts
- Provide detailed summary of all changes

## Success Criteria Checklist
- [ ] TypeScript compilation: PASS
- [ ] ESLint validation: PASS
- [ ] Unit test coverage ≥ 80%: PASS
- [ ] Integration tests: PASS
- [ ] Security validation: PASS
- [ ] Performance benchmarks: PASS
- [ ] Documentation: COMPLETE

## Feedback Loop Protocol
Each agent must provide structured feedback:
```typescript
interface ValidationFeedback {
  agent: 'developer' | 'qa' | 'security';
  status: 'pass' | 'fail' | 'warning';
  details: string;
  suggestions: string[];
  autoFixable: boolean;
}
```

Read and execute the PRP from: $ARGUMENTS

The PRP should be located at `.aipex/PRPs/generated/{TICKET_ID}.md` - use the ticket-based naming convention.

Proceed with autonomous implementation and validation. Only stop on critical security issues or unresolvable conflicts.