{ config, lib, ... }:

lib.mkIf config.ryan.features.programs.enable {
  programs.tmux = { enable = true; };

  programs.ghostty = {
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
