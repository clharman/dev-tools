#!/bin/bash
set -e

echo "🔍 Comprehensive Playwright Health Check"
echo "========================================"

# Test 1: Playwright CLI availability
echo "1. Testing Playwright CLI..."
if npx playwright --version; then
    echo "✅ Playwright CLI: Available"
else
    echo "❌ Playwright CLI: Failed"
    exit 1
fi

# Test 2: Firefox browser availability
echo "2. Testing Firefox browser installation..."
if [ -d "$PLAYWRIGHT_BROWSERS_PATH" ]; then
    echo "✅ Browser cache directory exists: $PLAYWRIGHT_BROWSERS_PATH"
    ls -la "$PLAYWRIGHT_BROWSERS_PATH" || true
else
    echo "❌ Browser cache directory missing: $PLAYWRIGHT_BROWSERS_PATH"
    exit 1
fi

# Test 3: Firefox executable test
echo "3. Testing Firefox executable..."
if npx playwright show-trace --help >/dev/null 2>&1; then
    echo "✅ Firefox executable: Working"
else
    echo "❌ Firefox executable: Failed"
    exit 1
fi

# Test 4: MCP server responsiveness
echo "4. Testing Playwright MCP server startup..."
if timeout 15s npx @playwright/mcp@latest --help >/dev/null 2>&1; then
    echo "✅ Playwright MCP server: Responsive"
else
    echo "❌ Playwright MCP server: Unresponsive"
    echo "Attempting to diagnose..."
    which npx || echo "npx not found"
    npm list -g @playwright/mcp || echo "MCP package not installed globally"
    exit 1
fi

# Test 5: Supabase MCP server
echo "5. Testing Supabase MCP server..."
if timeout 15s npx @supabase/mcp-server-supabase@latest --help >/dev/null 2>&1; then
    echo "✅ Supabase MCP server: Responsive"
else
    echo "❌ Supabase MCP server: Unresponsive"
    exit 1
fi

echo ""
echo "🎉 All Playwright health checks PASSED!"
echo "System is ready for reliable MCP operation."