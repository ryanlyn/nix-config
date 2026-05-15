{ config, lib, ... }:

lib.mkIf config.ryan.features.shell.enable {
  programs.starship = {
    enable = false;
    enableZshIntegration = false;

    # See docs here: https://starship.rs/config/
    # Symbols config configured in Flake.
    settings = {
      battery.display.threshold =
        25; # display battery information if charge is <= 25%
      directory.fish_style_pwd_dir_length =
        1; # turn on fish directory truncation
      directory.truncation_length = 2; # number of directories not to truncate
      memory_usage.disabled =
        true; # because it includes cached memory it's reported as full a lot
    };
  };
}
