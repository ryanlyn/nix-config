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
      #     "nix/nix.conf" = {
      #       source = ../../config/nix/nix.conf;
      #     };
      #     "alacritty/alacritty.yml" = {
      #       source = ../../config/alacritty/alacritty.yml;
      #     };
      #   "xmonad/xmonad.hs" = {
      #     source = ../../config/xmonad/xmonad.hs;
      #   };
      # "rofi/config.rasi"= {
      #     source = ../../config/rofi/config.rasi;
      #   };
    };
  };
}
