#!/bin/bash
set -e

# Configuration
CONTAINER_NAME="golden-cicd-app"
IMAGE_NAME="golden-cicd-python"
APP_ENV="${APP_ENV:-local}"
PORT="${PORT:-8000}"

echo "🚀 Starting deployment..."
echo "Environment: $APP_ENV"

# Stop and remove existing container if it exists (idempotent)
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "🛑 Stopping existing container..."
    docker stop $CONTAINER_NAME || true
    docker rm $CONTAINER_NAME || true
fi

# Run new container
echo "🐳 Starting new container..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:8000 \
    -e APP_ENV=$APP_ENV \
    $IMAGE_NAME

echo "✅ Deployment complete!"
echo "Container is running on port $PORT"

# Wait for container to be healthy
echo "⏳ Waiting for health check..."
sleep 3

# Verify health endpoint
if curl -f http://localhost:$PORT/health > /dev/null 2>&1; then
    echo "✅ Health check passed!"
else
    echo "❌ Health check failed!"
    exit 1
fi

# ============================================================================
# FUTURE AWS EC2 DEPLOYMENT (Currently Commented)
# ============================================================================
# Uncomment and configure when ready to deploy to EC2
#
# Prerequisites:
# - Add GitHub Secrets: EC2_HOST, EC2_USER, EC2_SSH_KEY
# - Ensure EC2 instance has Docker installed
# - Configure security groups to allow SSH (22) and app port (8000)
#
# EC2_HOST="${EC2_HOST}"
# EC2_USER="${EC2_USER}"
# IMAGE_TAR="golden-cicd-python.tar.gz"
#
# echo "📦 Saving Docker image..."
# docker save $IMAGE_NAME | gzip > $IMAGE_TAR
#
# echo "📤 Uploading to EC2..."
# scp -o StrictHostKeyChecking=no $IMAGE_TAR $EC2_USER@$EC2_HOST:/tmp/
#
# echo "🚀 Deploying on EC2..."
# ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST << 'ENDSSH'
#   cd /tmp
#   docker load < golden-cicd-python.tar.gz
#   
#   # Stop existing container
#   docker stop golden-cicd-app || true
#   docker rm golden-cicd-app || true
#   
#   # Run new container
#   docker run -d \
#     --name golden-cicd-app \
#     -p 8000:8000 \
#     -e APP_ENV=production \
#     --restart unless-stopped \
#     golden-cicd-python
#   
#   # Cleanup
#   rm golden-cicd-python.tar.gz
# ENDSSH
#
# echo "✅ EC2 Deployment complete!"
# ============================================================================
