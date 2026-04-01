{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.uv ];

  xdg.configFile."uv/uv.toml".text = ''
    exclude-newer = "7 days"
  '';

  xdg.configFile."pnpm/rc".text = ''
    minimum-release-age=10080
  '';

  home.file = lib.mkMerge [{
    ".npmrc".text = ''
      min-release-age=7
      ignore-scripts=true
    '';

    ".bunfig.toml".text = ''
      [install]
      minimumReleaseAge = 604800
    '';
  }];
}
