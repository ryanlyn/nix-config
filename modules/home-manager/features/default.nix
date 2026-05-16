{ lib, ... }:

let inherit (lib) mkEnableOption mkOption types;
in {
  options.local.features = {
    packageManagers.enable = mkEnableOption "package-manager tooling" // {
      default = true;
    };

    releaseAge.enable = mkEnableOption "package-manager release-age guards" // {
      default = true;
    };

    releaseAge.days = mkOption {
      type = types.ints.positive;
      default = 7;
      description =
        "Minimum release age in days for supported package managers.";
    };

    languages.enable = mkEnableOption "language toolchains" // {
      default = true;
    };

    shell.enable = mkEnableOption "interactive shell configuration" // {
      default = true;
    };

    programs.enable = mkEnableOption "common user programs" // {
      default = true;
    };
  };
}
