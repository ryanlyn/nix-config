{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.uv ];

  xdg.configFile."uv/uv.toml".text = ''
    exclude-newer = "7 days"
  '';

  xdg.configFile."pnpm/rc".text = ''
    minimum-release-age=10080
  '';

  home.sessionVariables = {
    NPM_CONFIG_IGNORE_SCRIPTS = "true";
    NPM_CONFIG_MIN_RELEASE_AGE = "7";
  };

  home.file = lib.mkMerge [{
    ".bunfig.toml".text = ''
      [install]
      minimumReleaseAge = 604800
    '';
  }];
}
