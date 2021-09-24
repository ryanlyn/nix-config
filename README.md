# Bootstrap
```bash
# bootstrap darwin
nix build '.#darwinConfigurations.personal.config.system.build.toplevel' -v --experimental-features 'nix-command flakes'
# bootstrap home-manager
nix run github:nix-community/home-manager --experimental-features 'nix-command flakes' --no-write-lock-file -- switch --flake '.#personal' -b backup
```

# Darwin
```bash
# switch
darwin-rebuild switch --flake '.#personal'
```


# Home Manager
```bash
# switch
home-manager switch --flake '.#personal'
# build
home-manager build --flake '.#personal'
```
