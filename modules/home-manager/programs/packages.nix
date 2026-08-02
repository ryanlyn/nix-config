{ config, lib, pkgs, ... }:

let isX86Linux = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
in lib.mkIf config.local.features.programs.enable {
  home.packages = [
    pkgs.awscli2
    pkgs.bandwhich
    pkgs.bat
    pkgs.bottom
    pkgs.coreutils
    pkgs.curl
    pkgs.direnv
    pkgs.devbox
    pkgs.eza
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
    # pkgs.neofetch
    pkgs.procs
    pkgs.ripgrep
    pkgs.tealdeer
    pkgs.vim
    pkgs.unzip
    pkgs.wget
  ] ++ lib.optionals isX86Linux [ pkgs.dust ];
}
