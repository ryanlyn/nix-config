# Installing Nix
```bash
# install nix
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon
nix-env -iA nixpkgs.nixFlakes  # optional
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
```

# Bootstrapping Darwin (Optional)
```bash
# bootstrap darwin
nix build '.#darwinConfigurations.personalArm64.config.system.build.toplevel' -v --experimental-features 'nix-command flakes' [--impure]
./result/sw/bin/darwin-rebuild switch --flake '.#personalArm64' [--impure]
```

# Bootstrapping Home Manager
## Darwin
```bash
nix run github:nix-community/home-manager --extra-experimental-features 'flakes nix-command' --no-write-lock-file -- switch --flake '.#personalArm64' -b backup
```
## Linux
Uncomment out `targets.genericLinux.enable = true;`. 
```bash
nix build --extra-experimental-features 'flakes nix-command' --no-link '.#homeConfigurations.personalx86Linux.activationPackage'
```

# Darwin Usage
- `nix-ds` - Darwin rebuild (personalArm64)

```bash
# switch
darwin-rebuild switch --flake '.#personalArm64'
./result/sw/bin/darwin-rebuild switch --flake '.#personalArm64' [--impure]
```

# Home Manager Usage
Make sure `targets.genericLinux.enable = true;` is commented out.

- `nix-hm-darwin` - Home Manager switch (personalArm64)
- `nix-hm-linux` - Home Manager switch (personalx86Linux)

```bash
# switch
home-manager switch --flake '.#personalArm64'
# build
home-manager build --flake '.#personalArm64'
```

# Misc

## Development Shell

```bash
nix develop
```

## Formatting
```bash
# Format all Nix files
nix run nixpkgs#nixfmt-classic -- ./**/*.nix
```


## Updating Flakes
```bash
nix flake update
```
