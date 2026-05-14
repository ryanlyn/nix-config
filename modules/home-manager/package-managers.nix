{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.uv pkgs.pnpm ];

  xdg.configFile."uv/uv.toml".text = ''
    exclude-newer = "7 days"
  '';

  xdg.configFile."pnpm/rc".text = ''
    minimum-release-age=10080
  '';

  home.sessionVariables = {
    NPM_CONFIG_IGNORE_SCRIPTS = "true";
    NPM_CONFIG_MIN_RELEASE_AGE = "7";
    PIP_UPLOADED_PRIOR_TO = "P7D";
  };

  home.file = lib.mkMerge [{
    ".bunfig.toml".text = ''
      [install]
      minimumReleaseAge = 604800
    '';
  }];
}
