{ config, ... }:

{
  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";

    configFile = {
      "p10k.zsh" = {
        source = ../../config/powerlevel10k/p10k.zsh;
      };
    };
  };
}
