# Bootstrap
```bash
# install nix
sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon

# install nix flakes
nix-env -iA nixpkgs.nixFlakes
nix-channel --add https://nixos.org/channels/nixpkgs-unstable

# bootstrap darwin
nix build '.#darwinConfigurations.personalArm64.config.system.build.toplevel' -v --experimental-features 'nix-command flakes' [--impure]
./result/sw/bin/darwin-rebuild switch --flake '.#personalArm64' [--impure]

# bootstrap home-manager
nix run github:nix-community/home-manager --experimental-features 'nix-command flakes' --no-write-lock-file -- switch --flake '.#personalArm64' -b backup

# bootstrap home-manager (linux)
nix build --extra-experimental-features 'flakes nix-command' --no-link '.#homeConfigurations.personalx86Linux.activationPackage'
```

# Darwin
```bash
# switch
darwin-rebuild switch --flake '.#personalArm64'
./result/sw/bin/darwin-rebuild switch --flake '.#personalArm64' [--impure]
```


# Home Manager
```bash
# switch
home-manager switch --flake '.#personalArm64'
# build
home-manager build --flake '.#personalArm64'
```
