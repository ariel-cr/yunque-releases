# Yunque — binary distribution

Native specialist agents for Godot game development in OpenCode, Codex, and Claude Code. This repository distributes installers and compiled binaries. Source code is maintained in a private repository.

## Install

Linux and macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/ariel-cr/yunque-releases/main/install.sh | bash
```

Windows, from PowerShell:

```powershell
irm https://raw.githubusercontent.com/ariel-cr/yunque-releases/main/install.ps1 | iex
```

The installer downloads the binary and registers seven specialists plus a coordination skill in every detected host. It preserves unrelated files and configuration. Successful installation displays the Yunque ASCII banner and a short confirmation; registration failures retain their diagnostic details.

Restart your host, then open your game directory. `project.godot` must be in the current directory or an ancestor.

## Use your usual chat

Ask for work normally in your host. It selects relevant specialists for game design, programming, art, audio, production, QA, or narrative. Simple questions do not require a whole team. The host supplies its model, tools, authentication, and permissions; skill selection and delegation depend on its capabilities and configuration.

Specialists consult relevant local knowledge cards and cite their sources when appropriate. They are specialized through instructions and reference material, rather than separately trained models. They still need to verify their work.

## Installation locations

The binary is installed to `~/.local/bin` on Linux/macOS or `%LOCALAPPDATA%\Yunque` on Windows. Agents use each host's native global directories:

| Host | Agent directory | Coordination skill |
|---|---|---|
| Codex | `~/.codex/agents` | `~/.agents/skills/yunque` |
| Claude Code | `~/.claude/agents` | `~/.claude/skills/yunque` |
| OpenCode | `~/.config/opencode/agents` | `~/.config/opencode/skills/yunque` |

Host configuration overrides are respected: `CODEX_HOME`, `CLAUDE_CONFIG_DIR`, `OPENCODE_CONFIG_DIR`, and `XDG_CONFIG_HOME`. Codex's personal skill directory is independent of `CODEX_HOME`.

If you install another host later, run `yunque install-agents`. You can choose one with `--agent codex`, `--agent claude`, or `--agent opencode`. `yunque agents-status` shows managed files, and `yunque uninstall-agents` removes only unmodified managed files.

To pin a version or installation directory in Bash, download the installer first and pass variables to the process that runs it:

```sh
curl -fsSL https://raw.githubusercontent.com/ariel-cr/yunque-releases/main/install.sh -o /tmp/install-yunque.sh
YUNQUE_VERSION=v0.1.0 YUNQUE_INSTALL_DIR="$HOME/.local/bin" bash /tmp/install-yunque.sh
```

PowerShell also supports the `YUNQUE_VERSION` and `YUNQUE_INSTALL_DIR` environment variables.

## Project bibles, context, and language

Each game keeps its memory in `.yunque/` next to `project.godot`:

```text
.yunque/
  contexto.md       # Current goal, state, and verification evidence
  decisiones.md     # Accepted decisions and their reasons
  pendientes.md     # Next steps and blockers
  assets.json       # References, provenance, and licenses
  biblias/          # Bibles for the relevant specialties
  personajes/       # Character canon and references
  memory.json       # Update language and document metadata
  .gdignore         # Exclude the memory directory from Godot imports
```

Agents are instructed to read these documents when resuming work. The coordinator merges and saves relevant updates at the end of a task. Updating Yunque does not delete game memory. Existing documents and bibles are discovered and preserved without automatic conversion.

**New content follows the language you use to speak to the AI.** Existing text keeps its language and is translated only on request. Paths, role identifiers, and technical fields remain stable. English repository documentation does not force English game documents.

The host writes and updates the documents. Yunque stores UTF-8 content and rejects writes based on an outdated document hash. Initialization creates directories and empty documents for the agent to populate with actual project facts. You do not need to run memory commands yourself.

You can share or back up memory through your project's version control. It does not include the full chat history and must not contain secrets. Model-driven reading and updating depend on the host following its native instructions. Restart the host after updates to load them.

## Assets and API keys

The host recommends suitable services when needed and offers to prepare an `.env` template. Only after consent does it create empty variables. Fill in keys locally; never paste them into chat. Existing `.env` content is preserved, and Git ignore rules are added.

Creating a template does not load environment variables in Godot, call a service's API, or authorize spending. Keep secrets out of exported games.

## Manual downloads and requirements

Download a binary from the [releases page](https://github.com/ariel-cr/yunque-releases/releases):

| Platform | Asset |
|---|---|
| Linux x86_64 | `yunque-linux-x86_64` |
| Windows x86_64 | `yunque-windows-x86_64.exe` |
| macOS Intel | `yunque-macos-x86_64` |
| macOS Apple Silicon | `yunque-macos-arm64` |

Python is not required to use a binary. You need a compatible host; Godot must be installed to run the local Godot utilities. After a manual download, run `yunque install-agents --binary /absolute/path/to/yunque`. On Windows, invoke the downloaded executable from PowerShell with its absolute path.

Global agents can remain visible outside Godot projects. Their instructions require them to stop, and Yunque's local tools reject project operations there. Yunque does not add a sandbox to the host's native tools.

Private project. Binaries are provided for authorized use.
