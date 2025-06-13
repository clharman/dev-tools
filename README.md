# Development Tools

This repository contains development tools and Docker images for Claude Code workflows.

## Claude Runner Image

Pre-built Docker image containing:
- Ubuntu 24.04
- Node.js 20 LTS  
- Playwright with Firefox
- MCP servers (@playwright/mcp, @supabase/mcp-server-supabase)

### Usage

```yaml
container:
  image: ghcr.io/clharman/dev-tools/claude-runner:latest
  options: --shm-size=2gb --user root
```

### Building

The image is automatically built and pushed to GitHub Container Registry when changes are made to:
- `docker/` directory
- `package*.json` files
- The build workflow itself

Manual build trigger: Go to Actions → "Build Claude Runner Image" → "Run workflow"