{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.local.features.programs.enable {
  programs.mise = {
    enable = true;
    globalConfig.tools.node = "24.18.0";
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    package = null;
  };
}
