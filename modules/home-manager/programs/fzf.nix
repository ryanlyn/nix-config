{ config, lib, ... }:

lib.mkIf config.local.features.programs.enable {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--info=inline"
      "--border"
      "--exact"
    ];
  };
}
