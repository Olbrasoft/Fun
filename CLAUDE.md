# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Linux home directory containing multiple .NET projects. The primary active project is **VirtualAssistant** at `/home/jirka/Olbrasoft/VirtualAssistant/`.

## Main Project: VirtualAssistant

Linux voice-controlled virtual assistant with inter-agent communication hub.

### Build & Test Commands

```bash
# Build
cd ~/Olbrasoft/VirtualAssistant && dotnet build

# Test (MUST pass before deployment)
dotnet test

# Deploy (CRITICAL - always use this script)
cd ~/Olbrasoft/VirtualAssistant && ./deploy/deploy.sh

# Manual deploy (emergency only)
dotnet publish src/VirtualAssistant.Service/VirtualAssistant.Service.csproj \
  -c Release -o ~/virtual-assistant/main/ --no-self-contained
```

**FORBIDDEN deployment paths:** `~/virtual-assistant/service/`, `~/virtual-assistant/` (root). Wrong path causes 404 errors.

### Services

| Service | Port | Command |
|---------|------|---------|
| virtual-assistant | 5055 | `systemctl --user {status|restart|stop} virtual-assistant.service` |
| logs-viewer | 5053 | `systemctl --user {status|restart} virtual-assistant-logs.service` |

Logs: `journalctl --user -u virtual-assistant.service -f`

### Architecture

Clean Architecture with CQRS pattern:
- **VirtualAssistant.Service** - ASP.NET Core main service (port 5055)
- **VirtualAssistant.Core** - Domain logic, AgentHubService, TaskDistributionService
- **VirtualAssistant.Voice** - TTS/STT with inline Whisper.net (GPU-accelerated), VAD (Silero ONNX), LLM routing
- **VirtualAssistant.Data** - Entities, DTOs
- **VirtualAssistant.Data.EntityFrameworkCore** - DbContext, migrations (auto-apply on startup)
- **VirtualAssistant.GitHub** - GitHub API, issue sync with embeddings

### Dependencies

| Dependency | URL | Purpose |
|------------|-----|---------|
| Ollama | localhost:11434 | Embeddings (nomic-embed-text, 768d) |
| PostgreSQL | localhost | DB with pgvector extension |

### Key API Endpoints

- `/api/github/search?q=...` - Semantic issue search
- `/api/hub/send` - Inter-agent messaging
- `/api/tasks/create` - Task queue (X-Agent-Name header)
- `/api/tts/speak` - Text-to-speech
- `/health` - Health check

## Development Standards

### Required Practices
- **.NET 10** (`net10.0`) for all projects
- **xUnit + Moq** for testing (NOT NUnit/NSubstitute)
- **Sub-issues** for task steps (NOT markdown checkboxes)
- **Push frequently** after every significant change
- **Never close issues** without user approval
- **Research first** - search existing solutions before implementing

### Git Workflow
- Each issue = separate branch (`fix/issue-N-desc`, `feature/issue-N-desc`)
- Commit + push after every step
- Close issue only after: tests pass + deployed + user approval

### Engineering Handbook
Reference files in `/home/jirka/GitHub/Olbrasoft/engineering-handbook/`:
- `development-guidelines/workflow-guide.md` - **Git workflow, GitHub issues, sub-issues, testing, secrets**
- `solid-principles/solid-principles-2025.md` - Modern SOLID principles
- `design-patterns/gof-design-patterns-2025.md` - Design patterns reference

## Olbrasoft Libraries

Located in `/home/jirka/Olbrasoft/`, each with its own solution:
- **Data** - CQRS, EF abstractions
- **Linq**, **Extensions**, **Mapping** - Utility libraries

Build/test: `dotnet build && dotnet test`

## MCP Servers

Custom servers in `/home/jirka/mcp-servers/`:
- TextToSpeechMcp, SpeechToTextMcp (C# .NET 8)

## Notifications (REQUIRED)

Use `mcp__notify__send_notification` to inform user about work progress via TTS.

**When to notify:**
1. **Task start** - When receiving a task, send summary of what you'll do (2-3 sentences)
2. **Task end** - When completing a task, send summary of results (success/failure, what was done)

**Format:**
- Language: Czech
- Length: Max 500 characters, 2-3 sentences
- Include issue number if applicable

**Examples:**
- Start: "Začínám pracovat na issue #15. Vytvořím MCP server pro notifikace a přidám ho do konfigurace."
- End: "Dokončil jsem issue #15. MCP server mcp-notify je hotový a funguje správně."

## Environment

- **OS**: Debian 13 (Trixie), GNOME, systemd
- **Terminal**: Kitty (use `kitty @` commands, never `gnome-terminal`)
- **Tools**: .NET 10, Node.js v20, Python 3.13, Git, Docker
- **SearXNG**: `http://localhost:8888` for web search

## Voice Output Constraints

**NEVER say these words in TTS output (triggers wake word loops):**

| Forbidden | Use instead |
|-----------|-------------|
| "Cline" | "program" |
| "stop" | "zastavit to" / "ukončit" |
| "stůj" | "počkej" |
| "ticho" | avoid entirely |
| "dost" | "stačí" |

## Communication Style

Be a critical thinking partner, not a yes-man:
- Good idea → "To je dobrý nápad"
- See alternatives → "Možná by to šlo i jinak"
- Have concerns → "Zamyslel bych se nad..."

User speaks Czech, but code and GitHub issues should be in English.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| 404 errors | Wrong deploy path - run `./deploy/deploy.sh` |
| Service fail | `journalctl --user -u virtual-assistant.service -n 50` |
| Port conflict | `ss -tulpn \| grep 5055` |
| Embeddings fail | `curl localhost:11434/api/tags` then `ollama pull nomic-embed-text` |
