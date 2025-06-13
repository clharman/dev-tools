FROM ubuntu:24.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Set up working directory
WORKDIR /workspace

# Copy package files for dependency installation
COPY package*.json ./

# Install project dependencies
RUN npm ci

# Pre-install Playwright with Firefox and all system dependencies
RUN npx playwright install firefox && \
    npx playwright install-deps firefox

# Verify Firefox installation
RUN npx playwright show-trace --help

# Cache browsers in permanent, predictable location
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers
RUN mkdir -p /opt/playwright-browsers && \
    PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers npx playwright install firefox

# Pre-install MCP packages globally to avoid version conflicts
RUN npm install -g @playwright/mcp@latest @supabase/mcp-server-supabase@latest

# Set environment variables for consistent behavior
ENV NODE_ENV=development
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/playwright-browsers
ENV PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

# Create comprehensive health check
COPY scripts/playwright-health-check.sh /usr/local/bin/playwright-health-check
RUN chmod +x /usr/local/bin/playwright-health-check

# Run final verification
RUN playwright-health-check