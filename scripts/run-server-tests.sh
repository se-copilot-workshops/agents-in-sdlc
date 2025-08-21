#!/bin/bash

# Determine project root
if [[ $(basename $(pwd)) == "scripts" || $(basename $(pwd)) == "server" ]]; then
    PROJECT_ROOT=$(pwd)/..
else
    PROJECT_ROOT=$(pwd)
fi

# Activate virtual environment
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    source "$PROJECT_ROOT/venv/Scripts/activate" || . "$PROJECT_ROOT/venv/Scripts/activate"
else
    source "$PROJECT_ROOT/venv/bin/activate" || . "$PROJECT_ROOT/venv/bin/activate"
fi

# Check if the virtual environment is activated
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "Virtual environment not activated. Running setup-env.sh..."
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        "$PROJECT_ROOT/scripts/setup-env.sh"
    else
        bash "$PROJECT_ROOT/scripts/setup-env.sh"
    fi
    
    # Re-activate virtual environment after setup
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        source "$PROJECT_ROOT/venv/Scripts/activate" || . "$PROJECT_ROOT/venv/Scripts/activate"
    else
        source "$PROJECT_ROOT/venv/bin/activate" || . "$PROJECT_ROOT/venv/bin/activate"
    fi
fi

# Run server tests
cd "$PROJECT_ROOT/server" || exit 1
echo "Running server tests..."

# Check if windows or linux/mac
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    py -m unittest discover -s tests -p "*.py"
else
    python3 -m unittest discover -s tests -p "*.py"
fi