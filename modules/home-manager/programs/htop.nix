{ config, lib, ... }:

lib.mkIf config.local.features.programs.enable {
  programs.htop = {
    enable = true;
    settings = {
      highlight_base_name = true;
      show_program_path = true;
      tree_view = true;
    };
  };
}
