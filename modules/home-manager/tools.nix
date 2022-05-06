{ pkgs, ... }:

{
  home.packages = [
    pkgs.awscli2
    pkgs.bandwhich
    pkgs.bat
    pkgs.bottom
    pkgs.coreutils
    pkgs.curl
    pkgs.direnv
    # pkgs.dust  # disable: unavailable on arm64
    pkgs.exa
    pkgs.fd
    # prefer non-hermetic installation because of gcloud plugins
    # see https://cloud.google.com/sdk/docs/install
    # pkgs.google-cloud-sdk 
    pkgs.grex
    pkgs.htop
    pkgs.httpie
    pkgs.lorri
    pkgs.jq
    pkgs.kpt
    pkgs.kubectl
    pkgs.kustomize
    pkgs.neofetch
    pkgs.procs
    pkgs.ripgrep
    pkgs.spacevim
    pkgs.tealdeer
    pkgs.vim
    pkgs.unzip
    pkgs.wget
  ];

  programs.broot = { enable = true; enableZshIntegration = true; };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.htop = {
    enable = true;
    settings = {
      highlight_base_name = true;
      show_program_path = true;
      tree_view = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--info=inline"
      "--border"
      "--exact"
    ];
  };

  programs.neovim = { enable = true; };

  programs.tmux = { enable = true; };

  programs.zoxide = { enable = true; enableZshIntegration = true; };
}
