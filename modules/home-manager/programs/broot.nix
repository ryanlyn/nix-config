{ config, lib, ... }:

lib.mkIf config.ryan.features.programs.enable {
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };
}
