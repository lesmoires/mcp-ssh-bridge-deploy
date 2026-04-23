FROM ubuntu:24.04

LABEL maintainer="lesmoires"
LABEL description="mcp-ssh-bridge — 338 sysadmin tools via SSH, Docker, systemd, monitoring"
LABEL org.opencontainers.image.source="https://github.com/lesmoires/mcp-ssh-bridge-deploy"

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    openssh-client \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Download and install mcp-ssh-bridge binary
RUN cd /tmp \
    && curl -fSL "https://github.com/muchiny/mcp-ssh-bridge/releases/latest/download/mcp-ssh-bridge-linux-x86_64.tar.gz" -o mcp.tar.gz \
    && tar xzf mcp.tar.gz \
    && mv mcp-ssh-bridge /usr/local/bin/ \
    && chmod +x /usr/local/bin/mcp-ssh-bridge \
    && rm -rf /tmp/mcp.tar.gz \
    && /usr/local/bin/mcp-ssh-bridge --version 2>&1 || true

# Create required directories
RUN mkdir -p /root/.config/mcp-ssh-bridge \
    /root/.ssh \
    /root/.local/share/mcp-ssh-bridge/audit

# Default entrypoint: keepalive (container runs as a background service)
# For MCP stdio mode, override with: mcp-ssh-bridge
ENTRYPOINT ["tail", "-f", "/dev/null"]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=15s \
    CMD mcp-ssh-bridge status || exit 1

# Ports
# 8900: SSE proxy (if sidecar is added)
EXPOSE 8900
