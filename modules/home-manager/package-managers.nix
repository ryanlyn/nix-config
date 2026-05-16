{ config, lib, pkgs, ... }:

let
  cfg = config.local.features;
  releaseAgeDays = cfg.releaseAge.days;
  releaseAgeMinutes = releaseAgeDays * 24 * 60;
  releaseAgeSeconds = releaseAgeDays * 24 * 60 * 60;
in lib.mkIf cfg.packageManagers.enable {
  home.packages = [ pkgs.uv pkgs.pnpm pkgs.deno pkgs.bun ];

  xdg.configFile."uv/uv.toml" = lib.mkIf cfg.releaseAge.enable {
    text = ''
      exclude-newer = "${toString releaseAgeDays} days"
    '';
  };

  xdg.configFile."pnpm/rc" = lib.mkIf cfg.releaseAge.enable {
    text = ''
      minimum-release-age=${toString releaseAgeMinutes}
    '';
  };

  home.sessionVariables = lib.mkIf cfg.releaseAge.enable {
    NPM_CONFIG_IGNORE_SCRIPTS = "true";
    NPM_CONFIG_MIN_RELEASE_AGE = toString releaseAgeDays;
    PIP_UPLOADED_PRIOR_TO = "P${toString releaseAgeDays}D";
  };

  home.file = lib.mkIf cfg.releaseAge.enable {
    ".bunfig.toml".text = ''
      [install]
      minimumReleaseAge = ${toString releaseAgeSeconds}
    '';
  };
}
