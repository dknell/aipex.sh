---
name: "Comprehensive Test Execution"
description: "Run all tests with coverage and performance validation"
---

# Comprehensive Test Execution Command

Execute full test suite:

1. **Unit Tests**: `jest --coverage --verbose`
2. **Integration Tests**: `jest --config jest.integration.config.js`
3. **E2E Tests**: `playwright test`
4. **Performance Tests**: `npm run test:performance`

## Coverage Requirements
- Minimum 80% statement coverage
- Minimum 75% branch coverage
- Minimum 75% function coverage
- Minimum 80% line coverage

## Performance Requirements
- Page load < 3 seconds
- API response < 500ms
- Memory usage within limits

Report detailed test results and coverage metrics.
Auto-generate missing tests for uncovered code when possible.

Success criteria: All tests pass with coverage above thresholds.