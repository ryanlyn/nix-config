# Bootstrap
```bash
# install nix flakes
nix-env -iA nixpkgs.nixFlakes
# bootstrap darwin
nix build '.#darwinConfigurations.personalArm64.config.system.build.toplevel' -v --experimental-features 'nix-command flakes' [--impure]
# bootstrap home-manager
nix run github:nix-community/home-manager --experimental-features 'nix-command flakes' --no-write-lock-file -- switch --flake '.#personalArm64' -b backup
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
