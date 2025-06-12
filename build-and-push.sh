#!/bin/bash
set -e

# Build the Docker image
echo "Building Docker image..."
docker build -t dekaregistry.cloudeka.id/cloudeka-system/mcp-slackbot:1.0.4 .

# Push the image
echo "Pushing Docker image..."
docker push dekaregistry.cloudeka.id/cloudeka-system/mcp-slackbot:1.0.4

echo "Image built and pushed successfully!"
echo "Now restart your Kubernetes deployment:"
echo "kubectl rollout restart deployment slackbot-mcp-slackbot" 