{
  description = "Nix system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # TODO: Re-evaluate whether the legacy SpaceVim compatibility pin is still needed.
    nixpkgs-spacevim.url =
      "github:nixos/nixpkgs/01f116e4df6a15f4ccdffb1bcd41096869fb385c";
    nixpkgs-uv.url = "github:nixos/nixpkgs/nixos-unstable";

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
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (flake-utils.lib) eachSystem;

      lib = nixpkgs.lib // home-manager.lib;

      overlays = [ ];

      supportedSystems = [ "aarch64-darwin" "x86_64-linux" ];
      isDarwin = system: (builtins.elem system lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      baseDarwinConfig = { pkgs, ... }: {
        environment.darwinConfig = "./modules/darwin";
        nix.package = pkgs.nixVersions.stable;
        nix.extraOptions =
          "\n          experimental-features = nix-command flakes\n        ";
      };

      mkDarwinConfig = { username, system ? "aarch64-darwin", baseModules ? [
        home-manager.darwinModules.home-manager
        baseDarwinConfig
        ./modules/darwin
      ], extraModules ? [ ] }:

        darwinSystem {
          system = system;
          modules = baseModules ++ extraModules ++ [{
            nixpkgs.overlays = overlays;
            system.primaryUser = username;
          }];
          specialArgs = { inherit inputs lib; };
        };

      mkHomeConfig = { username, system ? "aarch64-darwin"
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
            ++ [{ nixpkgs.overlays = overlays; }] ++ [{
              home = {
                username = username;
                homeDirectory = "${homePrefix system}/${username}";
                stateVersion = "21.11";
              };
              targets.genericLinux.enable = !isDarwin system;
            }];
        };
    in eachSystem supportedSystems (system:
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

        checks = {
          format = pkgs.runCommand "nixfmt-check" {
            nativeBuildInputs = [ pkgs.nixfmt-classic ];
            src = self;
          } ''
            cd "$src"
            nixfmt --check $(find . -name '*.nix' -not -path './.git/*')
            touch "$out"
          '';
        } // lib.optionalAttrs (system == "aarch64-darwin") {
          darwin-personalArm64 =
            self.darwinConfigurations.personalArm64.config.system.build.toplevel;
          darwin-personalArm64MacMini =
            self.darwinConfigurations.personalArm64MacMini.config.system.build.toplevel;
          home-personalArm64 =
            self.homeConfigurations.personalArm64.activationPackage;
          home-personalArm64MacMini =
            self.homeConfigurations.personalArm64MacMini.activationPackage;
        } // lib.optionalAttrs (system == "x86_64-linux") {
          home-personalx86Linux =
            self.homeConfigurations.personalx86Linux.activationPackage;
        };
      }) // {

        darwinConfigurations = {
          personalArm64 = mkDarwinConfig {
            username = "ryan";
            system = "aarch64-darwin";
            extraModules = [ ];
          };
          personalArm64MacMini = mkDarwinConfig {
            username = "ryan";
            system = "aarch64-darwin";
            extraModules = [
              { ids.gids.nixbld = 350; }
              {
                system.defaults.dock.orientation = nixpkgs.lib.mkForce "bottom";
                system.defaults.dock.tilesize = nixpkgs.lib.mkForce 42;
              }
            ];
          };
        };

        homeConfigurations = {
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
          personalArm64MacMini = mkHomeConfig {
            system = "aarch64-darwin";
            username = "ryan";
            extraModules = [ ];
          };
        };
      };
}
