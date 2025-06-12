# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
# Configure uv to use /tmp for cache and data (read-only filesystem compatibility)
ENV UV_CACHE_DIR=/tmp/.uv-cache
ENV UV_DATA_DIR=/tmp/.uv-data
ENV XDG_CACHE_HOME=/tmp/.cache
ENV XDG_DATA_HOME=/tmp/.local/share

# Install system dependencies including Node.js
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
rm kubectl

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies including uv
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install uv

# Copy application code
COPY mcp_simple_slackbot/ ./mcp_simple_slackbot/

# Expose port (if needed for health checks)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import sys; sys.exit(0)"

# Run the application
CMD ["python", "-m", "mcp_simple_slackbot.main"] 