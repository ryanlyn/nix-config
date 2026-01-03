# Plan: Managing Claude Code Settings & Plugins via Nix

## Overview

This document outlines options for declaratively managing Claude Code configuration through your nix-config repository, following the existing patterns and best practices.

---

## Current State

### Your nix-config patterns:
- **Flakes-based** with modular home-manager structure
- **XDG config sourcing** for raw dotfiles (`config/` → `~/.config/`)
- **Native home-manager modules** for tools with built-in support
- **Multi-host configs**: personalx86, personalArm64, canva, etc.

### Claude Code configuration files:
| File | Location | Purpose |
|------|----------|---------|
| `settings.json` | `~/.claude/` | Global user settings |
| `settings.json` | `.claude/` | Project shared settings |
| `settings.local.json` | `.claude/` | Project local settings |
| `CLAUDE.md` | `~/.claude/` or `.claude/` | Memory/context files |
| MCP servers | In settings.json | Plugin/tool connections |
| Hooks | In settings.json | Lifecycle scripts |
| Agents | `~/.claude/agents/` | Custom subagents |

---

## Option 1: XDG Config File Pattern (Simple)

**Approach**: Store Claude settings as raw JSON files in `config/claude/` and symlink to `~/.claude/`

### Structure:
```
nix-config/
├── config/
│   └── claude/
│       ├── settings.json      # Global settings
│       ├── CLAUDE.md          # Global memory file
│       └── agents/
│           └── custom-agent.md
└── modules/home-manager/
    └── config.nix             # Add xdg.configFile entries
```

### Implementation:
```nix
# In config.nix
home.file = {
  ".claude/settings.json" = { source = ../../config/claude/settings.json; };
  ".claude/CLAUDE.md" = { source = ../../config/claude/CLAUDE.md; };
  ".claude/agents" = { source = ../../config/claude/agents; recursive = true; };
};
```

### Pros:
- Follows existing patterns in your repo
- Simple to implement and understand
- Raw JSON files are easy to edit/debug
- Version controlled

### Cons:
- Static config - same for all hosts
- No conditional settings based on host/user
- Manual JSON editing (no type checking)

---

## Option 2: Declarative Nix Module (Flexible)

**Approach**: Create a custom home-manager module that generates Claude Code settings from Nix expressions

### Structure:
```
nix-config/
└── modules/home-manager/
    └── claude.nix             # New dedicated module
```

### Implementation:
```nix
# modules/home-manager/claude.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.claude-code;

  settingsFormat = pkgs.formats.json { };

in {
  options.programs.claude-code = {
    enable = mkEnableOption "Claude Code configuration";

    permissions = {
      allow = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Allowed operations";
        example = [ "Bash(git:*)" "WebSearch" ];
      };
      deny = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };

    mcpServers = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          command = mkOption { type = types.str; };
          args = mkOption { type = types.listOf types.str; default = []; };
          env = mkOption { type = types.attrsOf types.str; default = {}; };
        };
      });
      default = {};
      description = "MCP server configurations";
    };

    hooks = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "Lifecycle hooks (Stop, SessionStart, etc.)";
    };

    memory = mkOption {
      type = types.lines;
      default = "";
      description = "Content for CLAUDE.md memory file";
    };
  };

  config = mkIf cfg.enable {
    home.file.".claude/settings.json" = {
      source = settingsFormat.generate "claude-settings.json" {
        "$schema" = "https://json.schemastore.org/claude-code-settings.json";
        permissions = {
          allow = cfg.permissions.allow;
          deny = cfg.permissions.deny;
        };
        mcpServers = cfg.mcpServers;
        hooks = cfg.hooks;
      };
    };

    home.file.".claude/CLAUDE.md" = mkIf (cfg.memory != "") {
      text = cfg.memory;
    };
  };
}
```

### Usage in flake.nix or host config:
```nix
programs.claude-code = {
  enable = true;

  permissions.allow = [
    "Bash(git:*)"
    "Bash(nix:*)"
    "WebSearch"
    "Read"
  ];

  mcpServers = {
    filesystem = {
      command = "npx";
      args = [ "-y" "@anthropic/mcp-server-filesystem" "/home/user" ];
    };
  };

  hooks = {
    Stop = [ "~/.claude/hooks/git-check.sh" ];
  };

  memory = ''
    # Project Guidelines
    - Use Nix for all configuration
    - Follow functional programming patterns
  '';
};
```

### Pros:
- Type-safe configuration with Nix options
- Conditional settings per host (personalArm64 vs canva)
- Composable - can mix/match settings
- IDE autocomplete for options
- Validation at build time

### Cons:
- More complex to implement initially
- Need to maintain module as Claude Code evolves
- Learning curve for contributors

---

## Option 3: Hybrid Approach (Recommended)

**Approach**: Combine both patterns - Nix module for dynamic settings, raw files for static content

### Structure:
```
nix-config/
├── config/
│   └── claude/
│       ├── CLAUDE.md              # Static memory content
│       ├── hooks/
│       │   └── git-check.sh       # Hook scripts
│       └── agents/
│           └── nix-expert.md      # Custom agents
└── modules/home-manager/
    ├── claude.nix                 # Dynamic settings module
    └── config.nix                 # Static file linking
```

### Implementation:

**Static files (config.nix):**
```nix
home.file = {
  ".claude/CLAUDE.md" = { source = ../../config/claude/CLAUDE.md; };
  ".claude/hooks" = { source = ../../config/claude/hooks; recursive = true; };
  ".claude/agents" = { source = ../../config/claude/agents; recursive = true; };
};
```

**Dynamic settings (claude.nix):**
```nix
# Simpler module focused on permissions and MCP
{ config, lib, pkgs, ... }:
{
  options.programs.claude-code = {
    enable = lib.mkEnableOption "Claude Code";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkIf config.programs.claude-code.enable {
    home.file.".claude/settings.json".text =
      builtins.toJSON ({
        "$schema" = "https://json.schemastore.org/claude-code-settings.json";
      } // config.programs.claude-code.settings);
  };
}
```

**Per-host configuration (in flake.nix or host module):**
```nix
# Personal config
programs.claude-code = {
  enable = true;
  settings = {
    permissions.allow = [ "Bash(*)" "WebSearch" ];
    mcpServers = { /* personal servers */ };
  };
};

# Work config (canva)
programs.claude-code = {
  enable = true;
  settings = {
    permissions.allow = [ "Bash(git:*)" ];
    mcpServers = { /* work-approved servers */ };
  };
};
```

### Pros:
- Best of both worlds
- Static content (CLAUDE.md, hooks) stays readable
- Dynamic settings can vary by host
- Follows existing patterns
- Easier to maintain than full module

### Cons:
- Two places to look for config
- Slightly more complex mental model

---

## Option 4: Flake-Based Plugin Management

**Approach**: Use Nix flakes to pin and manage MCP server versions

### Structure:
```nix
# flake.nix additions
{
  inputs = {
    # ... existing inputs
    mcp-server-filesystem = {
      url = "github:anthropic/mcp-server-filesystem";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, mcp-server-filesystem, ... }: {
    # Package MCP servers via Nix
    packages.x86_64-linux.mcp-filesystem =
      pkgs.buildNpmPackage { /* ... */ };
  };
}
```

### Benefits:
- Reproducible MCP server versions
- Security auditing of dependencies
- Offline capability
- Nix store caching

### Trade-offs:
- Significant complexity
- Need to package each MCP server
- May lag behind upstream versions

---

## Recommended Approach: Option 3 (Hybrid)

For your use case, I recommend **Option 3** because:

1. **Matches existing patterns** - You already use XDG for static files
2. **Supports multi-host** - Different settings for personalArm64 vs canva
3. **Pragmatic complexity** - Not over-engineered but flexible
4. **Maintainable** - Easy to understand and modify

### Implementation Plan:

1. Create `config/claude/` directory structure
2. Add static files (CLAUDE.md, hooks, agents)
3. Create `modules/home-manager/claude.nix` module
4. Import in `modules/home-manager/default.nix`
5. Configure per-host settings
6. Test with `home-manager switch`

---

## MCP Server Best Practices

### Security:
- Only use trusted, audited MCP servers
- Prefer official Anthropic servers when available
- Review permissions before enabling

### Performance:
- Disable unused servers (reduces token overhead)
- Use local servers for sensitive data
- Set appropriate timeouts

### Recommended Starter Servers:
```nix
mcpServers = {
  # File system access (official)
  filesystem = {
    command = "npx";
    args = [ "-y" "@anthropic/mcp-server-filesystem" "~" ];
  };

  # Git operations
  git = {
    command = "npx";
    args = [ "-y" "@anthropic/mcp-server-git" ];
  };

  # Brave Search (if API key available)
  brave-search = {
    command = "npx";
    args = [ "-y" "@anthropic/mcp-server-brave-search" ];
    env = { BRAVE_API_KEY = "from-secrets"; };
  };
};
```

---

## Questions for Clarification

1. **Multi-host needs**: Do you need different Claude configs for personal vs work machines?
2. **MCP servers**: Which MCP servers do you want to use? (filesystem, git, search, custom?)
3. **Hooks**: What lifecycle hooks would be useful? (git validation, linting, etc.)
4. **CLAUDE.md content**: What project guidelines should Claude remember?
5. **Secrets handling**: How should API keys for MCP servers be managed?

---

## Next Steps

Once you choose an approach, I can:
1. Implement the chosen option
2. Create the module and file structure
3. Add sample configurations
4. Test the setup
5. Commit and push to the branch
