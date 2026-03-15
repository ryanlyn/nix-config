# Installing Nix
```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

# Bootstrapping Darwin
```bash
nix build '.#darwinConfigurations.personalArm64.config.system.build.toplevel' -v

# rename if first install
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin

sudo ./result/sw/bin/darwin-rebuild switch --flake '.#personalArm64'
```

Configs: `personalArm64` (MacBook Pro), `personalArm64` (Mac Mini)

# Bootstrapping Home Manager
## Darwin
```bash
nix run github:nix-community/home-manager --no-write-lock-file -- switch --flake '.#personalArm64' -b backup
```
## Linux
```bash
nix build --no-link '.#homeConfigurations.personalx86Linux.activationPackage'
```

# Darwin Usage
- `nix-ds` - Darwin rebuild

```bash
darwin-rebuild switch --flake '.#personalArm64'
```

# Home Manager Usage
- `nix-hm-darwin` - Home Manager switch (personalArm64)
- `nix-hm-linux` - Home Manager switch (personalx86Linux)

```bash
home-manager switch --flake '.#personalArm64'
```

# Misc

## Development Shell
```bash
nix develop
```

## Formatting
```bash
nix run nixpkgs#nixfmt-classic -- ./**/*.nix
```

## Updating Flakes
```bash
nix flake update
```
