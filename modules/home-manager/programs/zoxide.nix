{ config, lib, ... }:

lib.mkIf config.local.features.programs.enable {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
