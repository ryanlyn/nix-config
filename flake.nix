{
  description = "Nix system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, flake-utils, ... }:

    let
      inherit (darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (flake-utils.lib) eachDefaultSystem eachSystem;
      inherit (builtins) listToAttrs map;

      lib = nixpkgs.lib // home-manager.lib;

      overlays = [ ];

      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
      isDarwin = system: (builtins.elem system lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      baseDarwinConfig = { pkgs, ... }: {
        environment.darwinConfig = "./modules/darwin";
        nix.package = pkgs.nixVersions.stable;
        nix.extraOptions =
          "\n          experimental-features = nix-command flakes\n          extra-platforms = aarch64-darwin x86_64-darwin\n        ";
      };

      mkDarwinConfig = { system ? "x86_64-darwin", baseModules ? [
        home-manager.darwinModules.home-manager
        baseDarwinConfig
        ./modules/darwin
      ], extraModules ? [ ] }:

        darwinSystem {
          system = system;
          modules = baseModules ++ extraModules
            ++ [{ nixpkgs.overlays = overlays; }];
          specialArgs = { inherit inputs lib; };
        };

      mkHomeConfig = { username, system ? "x86_64-darwin"
        , baseModules ? [ ./modules/home-manager ], extraModules ? [ ] }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = overlays;
          };
        in homeManagerConfiguration rec {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = baseModules ++ extraModules
            ++ [{ nixpkgs.overlays = overlays; }] ++ [
              {
                home = {
                  username = username;
                  homeDirectory = "${homePrefix system}/${username}";
                  stateVersion = "21.11";
                };
              }
            ];
        };
    in eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = overlays;
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "nix-config";
          packages = with pkgs;
            [ git nixfmt-classic ]
            ++ [ inputs.home-manager.packages.${system}.default ];
        };

        checks = lib.optionalAttrs (isDarwin system) {
          darwin = if system == "aarch64-darwin" then
            self.darwinConfigurations.personalArm64.config.system.build.toplevel
          else
            self.darwinConfigurations.personalx86.config.system.build.toplevel;
        };
      }) // {

        darwinConfigurations = {
          personalx86 = mkDarwinConfig {
            system = "x86_64-darwin";
            # todo: add profiles
            extraModules = [ ];
          };
          personalArm64 = mkDarwinConfig {
            system = "aarch64-darwin";
            extraModules = [ ];
          };
          canva = mkDarwinConfig {
            # todo: add profiles
            extraModules = [ ];
          };
        };

        homeConfigurations = {
          personalx86 = mkHomeConfig {
            system = "x86_64-darwin";
            username = "ryan";
            extraModules = [ ];
          };
          personalx86Linux = mkHomeConfig {
            system = "x86_64-linux";
            username = "ryan";
            extraModules = [ ];
          };
          personalArm64 = mkHomeConfig {
            system = "aarch64-darwin";
            username = "ryan";
            extraModules = [ ];
          };
          canva = mkHomeConfig {
            username = "ryan.l";
            extraModules = [ ];
          };
        };
      };
}
