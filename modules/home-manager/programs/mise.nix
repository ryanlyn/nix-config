{ config, lib, ... }:

lib.mkIf config.ryan.features.programs.enable {
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };
}
