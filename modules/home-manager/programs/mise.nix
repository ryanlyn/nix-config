{ config, lib, ... }:

lib.mkIf config.local.features.programs.enable {
  programs.mise = {
    enable = true;
    enableZshIntegration = false;
    globalConfig.tools.node = "24.18.0";
  };
}
