FROM ubuntu:24.04

LABEL maintainer="lesmoires"
LABEL description="mcp-ssh-bridge — 338 sysadmin tools via SSH, Docker, systemd, monitoring"
LABEL org.opencontainers.image.source="https://github.com/lesmoires/mcp-ssh-bridge-deploy"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    openssh-client \
    rsync \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && curl -fSL "https://github.com/muchiny/mcp-ssh-bridge/releases/latest/download/mcp-ssh-bridge-linux-x86_64.tar.gz" -o mcp.tar.gz \
    && tar xzf mcp.tar.gz \
    && mv mcp-ssh-bridge /usr/local/bin/ \
    && chmod +x /usr/local/bin/mcp-ssh-bridge \
    && rm -rf /tmp/mcp.tar.gz

RUN mkdir -p /root/.config/mcp-ssh-bridge \
    /root/.ssh \
    /root/.local/share/mcp-ssh-bridge/audit

# Create a minimal config so the healthcheck works
RUN echo "hosts: {}" > /root/.config/mcp-ssh-bridge/config.yaml \
    && chmod 640 /root/.config/mcp-ssh-bridge/config.yaml

ENTRYPOINT ["tail", "-f", "/dev/null"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=15s \
    CMD mcp-ssh-bridge --version > /dev/null 2>&1 || exit 1

EXPOSE 8900
