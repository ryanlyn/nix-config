{ config, lib, pkgs, ... }:

{
  imports = [
    ./config.nix
    ./git.nix
    ./languages.nix
    ./shells.nix
    ./tools.nix
  ];

  # the following required attributes are injected by flakes:
  #   - home.username
  #   - home.homeDirectory

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # enable settings that make Home Manager work better on GNU/Linux distributions other than NixOS
  targets.genericLinux.enable = true;
}
