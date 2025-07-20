---
name: "Enhanced PRP Generator with Multi-Agent Validation"
description: "Generate comprehensive PRPs with TypeScript, testing, and security context"
---

# Enhanced PRP Generation for Enterprise Features

## Instructions
You are the Developer Agent in a multi-agent system. Generate a comprehensive PRP that includes context for TypeScript validation, ESLint compliance, testing requirements, and security considerations.

## Pre-Research Phase
1. **Codebase Analysis**: Review existing TypeScript patterns, interfaces, and architectural decisions
2. **Testing Patterns**: Analyze current test structure, coverage requirements, and testing utilities
3. **Security Context**: Check existing security patterns, authentication flows, and compliance requirements
4. **Configuration Review**: Examine tsconfig.json, eslint config, and testing setup

## Research Process
Read the feature specification from: $ARGUMENTS

### Ticket ID Extraction
1. **Extract Ticket ID**: Parse the TICKET ID from the INITIAL.md file (first section)
2. **Fallback Naming**: If no ticket ID found, use timestamp format: YYYY-MM-DD-HHMMSS
3. **PRP Filename**: Use extracted ticket ID for naming: `.aipex/PRPs/generated/{TICKET_ID}.md`

### Context Gathering Requirements
1. **TypeScript Context**
   - Review existing interfaces and types
   - Identify reusable type definitions
   - Check strict mode compliance patterns

2. **Testing Context** 
   - Analyze existing test patterns
   - Review coverage requirements (minimum 80%)
   - Check integration test setup with Playwright

3. **Security Context**
   - Review security validation rules
   - Check dependency security requirements
   - Analyze authentication/authorization patterns

4. **Performance Context**
   - Check existing performance benchmarks
   - Review optimization patterns
   - Identify performance testing requirements

## PRP Structure Requirements

### 1. Feature Specification
- Clear TypeScript interfaces for all data structures
- Detailed functional requirements
- Security and performance requirements
- Integration points with existing systems

### 2. Implementation Plan
- Step-by-step implementation approach
- TypeScript-first development strategy
- Test-driven development plan
- Security considerations at each step

### 3. Validation Gates
- TypeScript compilation checkpoints
- ESLint validation requirements
- Unit test coverage targets (minimum 80%)
- Integration test scenarios
- Security validation checkpoints

### 4. Multi-Agent Review Process
- Developer agent implementation tasks
- QA agent review criteria
- Security agent validation requirements
- Feedback loop definitions

### 5. Success Criteria
- All TypeScript compilation without errors
- 100% ESLint compliance
- Test coverage above threshold
- Security validation passed
- Performance benchmarks met

## Critical Instructions
- Include comprehensive TypeScript type definitions
- Specify exact test coverage requirements
- Detail security validation steps
- Include performance benchmarks
- Define clear validation checkpoints
- Ensure autonomous operation capability

Generate the PRP and save it to `.aipex/PRPs/generated/{TICKET_ID}.md` using the extracted ticket ID.

Score the PRP confidence level (1-10) for autonomous implementation success.

Remember: The goal is enterprise-grade, production-ready code through comprehensive context and multi-agent validation.