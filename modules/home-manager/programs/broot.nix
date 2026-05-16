{ config, lib, ... }:

lib.mkIf config.local.features.programs.enable {
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };
}
