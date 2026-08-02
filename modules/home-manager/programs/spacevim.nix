{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  legacyPkgs = inputs.nixpkgs-spacevim.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  spacevimConfig = {
    custom_plugins = [
      {
        merged = false;
        name = "lilydjwg/colorizer";
      }
    ];

    layers = [
      { name = "default"; }
      {
        enable = true;
        name = "colorscheme";
      }
      { name = "fzf"; }
      {
        default_height = 30;
        default_position = "top";
        name = "shell";
      }
      { name = "edit"; }
      { name = "VersionControl"; }
      { name = "git"; }
      {
        auto-completion-return-key-behavior = "complete";
        auto-completion-tab-key-behavior = "cycle";
        autocomplete_method = "coc";
        name = "autocomplete";
      }
      { name = "lang#python"; }
      { name = "lang#ruby"; }
      { name = "lang#nix"; }
      { name = "lang#java"; }
      { name = "lang#kotlin"; }
      { name = "lang#sh"; }
      { name = "lang#html"; }
      { name = "treesitter"; }
    ];

    options = {
      buffer_index_type = 4;
      colorscheme = "gruvbox";
      colorscheme_bg = "dark";
      enable_guicolors = true;
      enable_statusline_mode = true;
      enable_tabline_filetype_icon = true;
      statusline_separator = "fire";
      timeoutlen = 500;
    };
  };
  spacevimTreesitterConfig = pkgs.writeText "spacevim-treesitter.lua" ''
    local M = {}

    function M.setup()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "html",
          "java",
          "javascript",
          "json",
          "kotlin",
          "lua",
          "markdown",
          "markdown_inline",
          "nix",
          "python",
          "ruby",
          "toml",
          "vim",
          "yaml",
        },
        sync_install = false,
        auto_install = false,
        parser_install_dir = vim.fn.stdpath("data") .. "/site",
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end

    return M
  '';
  spacevim =
    (legacyPkgs.spacevim.override { spacevim_config = spacevimConfig; }).overrideAttrs
      (old: {
        postPatch = (old.postPatch or "") + ''
          cp ${spacevimTreesitterConfig} lua/spacevim/treesitter.lua
          substituteInPlace autoload/SpaceVim/custom.vim \
            --replace-fail \
              'if getftime(resolve(global_config)) < getftime(resolve(global_config_cache))' \
              'if 0'
        '';
      });
in
lib.mkIf config.local.features.programs.enable {
  home.packages = [ spacevim ];
}
