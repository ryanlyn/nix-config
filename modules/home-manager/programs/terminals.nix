{ config, lib, pkgs, ... }:

lib.mkIf config.local.features.programs.enable {
  programs.tmux = { enable = true; };

  programs.ghostty = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    package = null; # ghostty installed via dmg/homebrew
    enableZshIntegration = true;
    settings = {
      theme = "Monokai Pro Octagon";
      background-opacity = 0.85;
      background-blur = 16;
      macos-titlebar-style = "tabs";
    };
  };
}
