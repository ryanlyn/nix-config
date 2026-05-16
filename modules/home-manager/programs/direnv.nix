{ config, lib, ... }:

lib.mkIf config.local.features.programs.enable {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    mise.enable = true;
    nix-direnv.enable = true;
  };
}
