{ config, lib, ... }:

lib.mkIf config.ryan.features.programs.enable {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
