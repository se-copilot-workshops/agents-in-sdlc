#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Store initial directory and script directory
INITIAL_DIR=$(pwd)
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Check if we're in scripts, client, or server directory and navigate up one level
current_directory=$(basename $(pwd))
if [[ "$current_directory" =~ ^(scripts|client|server)$ ]]; then
    cd ..
fi

echo "Starting API (Flask) server..."

# Source environment setup script
source "${SCRIPT_DIR}/setup-env.sh"

# Continue with server startup
cd server || {
    echo "Error: server directory not found"
    cd "$INITIAL_DIR"
    exit 1
}
export FLASK_DEBUG=1
export FLASK_PORT=5100

# Use appropriate Python command based on OS
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    py app.py &
else
    python3 app.py &
fi

# Store the Python server process ID
SERVER_PID=$!

echo "Starting client (Astro)..."
cd ../client || {
    echo "Error: client directory not found"
    cd "$INITIAL_DIR"
    exit 1
}
npm install
npm run dev -- --no-clearScreen &

# Store the SvelteKit server process ID
CLIENT_PID=$!

# Sleep for 3 seconds
sleep 5

# Display the server URLs
echo -e "\n${GREEN}Server (Flask) running at: http://localhost:5100${NC}"
echo -e "${GREEN}Client (Astro) server running at: http://localhost:4321${NC}\n"

echo "Ctl-C to stop the servers"

# Function to handle script termination
cleanup() {
    echo "Shutting down servers..."
    
    # Kill processes and their child processes
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        taskkill //F //T //PID $SERVER_PID 2>/dev/null
        taskkill //F //T //PID $CLIENT_PID 2>/dev/null
    else
        # Send SIGTERM first to allow graceful shutdown
        kill -TERM $SERVER_PID 2>/dev/null
        kill -TERM $CLIENT_PID 2>/dev/null
        
        # Wait briefly for graceful shutdown
        sleep 2
        
        # Then force kill if still running
        if ps -p $SERVER_PID > /dev/null 2>&1; then
            pkill -P $SERVER_PID 2>/dev/null
            kill -9 $SERVER_PID 2>/dev/null
        fi
        
        if ps -p $CLIENT_PID > /dev/null 2>&1; then
            pkill -P $CLIENT_PID 2>/dev/null
            kill -9 $CLIENT_PID 2>/dev/null
        fi
    fi

    # Deactivate virtual environment if active
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        deactivate
    fi

    # Return to initial directory
    cd "$INITIAL_DIR"
    exit 0
}

# Trap multiple signals
trap cleanup SIGINT SIGTERM SIGQUIT EXIT

# Keep the script running
wait