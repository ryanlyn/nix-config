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

  outputs =
    inputs@{ self
    , nixpkgs
    , darwin
    , home-manager
    , flake-utils
    , ...
    }:

    let
      inherit (darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      inherit (flake-utils.lib) eachDefaultSystem eachSystem;
      inherit (builtins) listToAttrs map;

      lib = nixpkgs.lib // home-manager.lib;

      overlays = [ ];

      supportedSystems = [ "x86_64-darwin" "x86_64-linux" ];
      isDarwin = system: (builtins.elem system lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      baseDarwinConfig = { pkgs, ... }: {
        environment.darwinConfig = "./modules/darwin";
        nix.package = pkgs.nixFlakes;
        nix.extraOptions = "experimental-features = nix-command flakes";
      };

      mkDarwinConfig =
        { system ? "x86_64-darwin"
        , baseModules ? [ home-manager.darwinModules.home-manager baseDarwinConfig ./modules/darwin ]
        , extraModules ? [ ]
        }:

        darwinSystem {
          modules = baseModules ++ extraModules ++ [{ nixpkgs.overlays = overlays; }];
          specialArgs = { inherit inputs lib; };
        };

      mkHomeConfig =
        { username
        , system ? "x86_64-darwin"
        , baseModules ? [ ./modules/home-manager ]
        , extraModules ? [ ]
        }:

        homeManagerConfiguration rec {
          inherit system username;
          homeDirectory = "${homePrefix system}/${username}";
          stateVersion = "21.11";
          # extraSpecialArgs = { inherit inputs lib; };
          configuration = {
            imports = baseModules ++ extraModules ++ [{ nixpkgs.overlays = overlays; }];
          };
        };

    in
    {

      darwinConfigurations = {
        personal = mkDarwinConfig {
          # todo: add profiles
          extraModules = [ ];
        };
        canva = mkDarwinConfig {
          # todo: add profiles
          extraModules = [ ];
        };
      };

      homeConfigurations = {
        personal = mkHomeConfig {
          username = "ryan";
          extraModules = [ ];
        };

        canva = mkHomeConfig {
          username = "ryan.l";
          extraModules = [ ];
        };
      };

      checks = listToAttrs (
        (map
          (system: {
            name = system;
            value = { darwin = self.darwinConfigurations.personal.config.system.build.toplevel; };
          })
          lib.platforms.darwin
        )
      );
    };
}
