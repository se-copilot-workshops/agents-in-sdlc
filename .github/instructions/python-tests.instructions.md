---
applyTo: 'server/tests/test_*.py'
---

# Testing notes

- Tests should create shared data at the top to be used for the tests below
- Include tests for success and for data not returned
- Use a in-memory SQLite when testing data
- Utilize setup and teardown functions to create and destroy the database for testing
    - Ensure the database is properly closed with `db.engine.dispose()`
