# Endpoint creation guidelines

## Endpoint notes

- Endpoints are created in Flask using blueprints
- Create a centralized function for accessing data
- All endpoints require tests
    - Use the `unittest` module for testing
    - All tests must pass
    - [A script is provided to run tests](../../scripts/run-server-tests.sh)

## Project notes

- The Python virtual environment is located in the root of the project in a **venv** folder
- Register all blueprints in [the app entrypoint](../../server/app.py)
- Use the [test instructions](./python-tests.instructions.md) when creating tests

## Prototype files

- [Endpoint prototype](../../server/routes/games.py)
- [Tests prototype](../../server/tests/test_games.py)
