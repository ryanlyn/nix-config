# Global Claude Code Guidelines

## Environment

- This is a Nix-managed system using home-manager
- Prefer declarative configuration over imperative changes
- Use `nix` commands for package management

## Coding Standards

- Follow functional programming patterns where appropriate
- Keep configurations modular and composable
- Document non-obvious decisions

## Nix Conventions

- Use `nixfmt` for formatting Nix files
- Prefer `home-manager` modules over raw dotfiles when available
- Test changes with `home-manager build` before switching
