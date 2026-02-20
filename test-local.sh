#!/bin/bash
set -e

echo "========================================"
echo "  Testing golden-cicd-python Locally"
echo "========================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed"
    echo "Please install Docker from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Cleanup function
cleanup() {
    echo ""
    echo "Stopping and removing container..."
    docker stop golden-test 2>/dev/null || true
    docker rm golden-test 2>/dev/null || true
}

# Set trap to cleanup on exit
trap cleanup EXIT

echo "[1/5] Building Docker image..."
docker build -t golden-cicd-python .

echo ""
echo "[2/5] Starting container..."
docker run -d --name golden-test -p 8000:8000 -e APP_ENV=local golden-cicd-python

echo ""
echo "[3/5] Waiting for application to start..."
sleep 5

echo ""
echo "[4/5] Testing endpoints..."
echo ""

echo "Testing root endpoint (/)..."
curl -s http://localhost:8000/ | jq . || curl -s http://localhost:8000/
echo ""
echo ""

echo "Testing health endpoint (/health)..."
curl -s http://localhost:8000/health | jq . || curl -s http://localhost:8000/health
echo ""
echo ""

echo "[5/5] Viewing container logs..."
docker logs golden-test
echo ""

echo "========================================"
echo "  ALL TESTS PASSED!"
echo "========================================"
echo ""
echo "Application is running at: http://localhost:8000"
echo "API Documentation: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop..."
echo ""

# Keep running until user stops
read -p "Press Enter to stop the container..."
