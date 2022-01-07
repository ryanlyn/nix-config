{ config, pkgs, ... }:


{
  imports = [
    ./system.nix
    ./homebrew.nix
  ];
  # These are defined in flake.nix:
  # environment.darwinConfig = "$HOME/nix-config/modules/darwin";
  # nix.package = pkgs.nixFlakes;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.bashInteractive
    # nix  # disable: not needed with flakes
    # pkgs.niv  # disable: not needed with flakes
    pkgs.nixpkgs-fmt
  ];

  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.fish.enable = true;
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
