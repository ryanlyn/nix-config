{ config, lib, pkgs, ... }:

let
  cfg = config.local.features;
  releaseAgeDays = cfg.releaseAge.days;
  releaseAgeMinutes = releaseAgeDays * 24 * 60;
  releaseAgeSeconds = releaseAgeDays * 24 * 60 * 60;
  uvSupportsReleaseAge = lib.versionAtLeast pkgs.uv.version "0.11.4";
in lib.mkIf cfg.packageManagers.enable {
  home.packages = [ pkgs.uv pkgs.pnpm pkgs.deno pkgs.bun ];

  warnings = lib.optional (cfg.releaseAge.enable && !uvSupportsReleaseAge)
    "uv ${pkgs.uv.version} does not support relative release-age guards; skipping uv exclude-newer configuration.";

  xdg.configFile."uv/uv.toml" =
    lib.mkIf (cfg.releaseAge.enable && uvSupportsReleaseAge) {
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
    PIP_UPLOADED_PRIOR_TO = "P${toString releaseAgeDays}D";
  };

  home.file = lib.mkIf cfg.releaseAge.enable {
    ".bunfig.toml".text = ''
      [install]
      minimumReleaseAge = ${toString releaseAgeSeconds}
    '';
  };
}
