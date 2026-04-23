#!/bin/bash
# Post-deploy test script
CONTAINER="mcp-ssh-bridge"

echo "=== mcp-ssh-bridge version ==="
docker exec $CONTAINER mcp-ssh-bridge --version

echo ""
echo "=== Config check ==="
docker exec $CONTAINER mcp-ssh-bridge status 2>&1 | head -5

echo ""
echo "=== Test: uptime ==="
docker exec $CONTAINER mcp-ssh-bridge exec moiria-claw "uptime" 2>&1 | grep -E "up|Error"

echo ""
echo "=== Test: docker ps ==="
docker exec $CONTAINER mcp-ssh-bridge exec moiria-claw "docker ps --format '{{.Names}}'" 2>&1 | grep -v "INFO\|ERROR\|WARN\|Audit" | grep -v "^Host:\|^Command:\|^Exit\|^Duration\|^---"

echo ""
echo "=== Health ==="
docker ps --filter name=$CONTAINER --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
