# mcp-ssh-bridge Deploy

Coolify deployment for [mcp-ssh-bridge](https://github.com/muchiny/mcp-ssh-bridge) — 338 sysadmin tools via SSH, Docker, systemd, monitoring, and more.

## Architecture

```
┌──────────────────────────────────────────────────────┐
│  Coolify (moiria-claw)                               │
│                                                      │
│  ┌──────────────────────────────────────────────┐   │
│  │  Container: mcp-ssh-bridge                    │   │
│  │  Image: mcp-ssh-bridge:local                  │   │
│  │  Base: Ubuntu 24.04 + Rust binary v1.12.0     │   │
│  │  Entrypoint: tail -f /dev/null (keepalive)   │   │
│  │                                              │   │
│  │  Volumes:                                     │   │
│  │  ├── config/config.yaml (ro)                 │   │
│  │  ├── config/ssh/id_ed25519 (ro)              │   │
│  │  ├── config/ssh/known_hosts (ro)             │   │
│  │  └── data/audit/ (rw)                        │   │
│  └──────────────────────────────────────────────┘   │
│                                                      │
│  SSH → moiria-claw, moiria-coolify, agnarsl-server  │
└──────────────────────────────────────────────────────┘
```

## Quick Start

### Deploy via Coolify

1. **Coolify UI**: New Application → Connect to this repo
2. **Build pack**: Dockerfile
3. **Project**: Moiria Claw
4. **Server**: moiria-claw

### Build Locally

```bash
docker build -t mcp-ssh-bridge:local .
docker run --rm mcp-ssh-bridge:local mcp-ssh-bridge status
```

### Configuration

1. Copy `config/config-template.yaml` → `config/config.yaml`
2. Add your hosts with SSH key paths
3. Place your SSH private key in `config/ssh/id_ed25519`
4. Run `ssh-keyscan` to populate `config/ssh/known_hosts`
5. Deploy

## Security

- **Strict mode** by default — only whitelisted commands allowed
- **Secret redaction** — 62+ builtin patterns + entropy detection
- **Audit logging** — tamper-proof session recording
- **Blacklist** — always enforced (rm -r, mkfs, dd, curl|sh, etc.)
- **Elicitation** — opt-in confirmation for destructive operations

## Updating the Binary

When a new version of mcp-ssh-bridge is released:

1. Update the Dockerfile `RUN curl ...` URL if needed
2. Push to trigger rebuild
3. Coolify will rebuild and redeploy automatically

## Tool Groups

~30 groups enabled (~200 tools):
- Core SSH, file ops, Docker, systemd, monitoring, databases, network, security, backup

~44 groups disabled:
- Windows, Kubernetes, Helm, ESXi, Ansible, Terraform, cloud providers, etc.

See `docs/TOOL_GROUPS.md` for the full list.

## License

MIT (mcp-ssh-bridge by muchiny)
