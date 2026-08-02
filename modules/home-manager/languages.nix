{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.local.features.languages.enable {
  home.packages = [
    # python
    pkgs.pipenv
    (pkgs.python313.withPackages (p: [
      # p.black # disable: broken uvloop dependency
      p.flake8
      p.mypy
      p.pip
      # p.poetry # disable: collision
      p.pylint
      p.virtualenv
    ]))
    pkgs.ruff
    pkgs.basedpyright

    # haskell
    pkgs.ghc
    pkgs.stack

    # rust
    pkgs.rustup

    # terraform
    pkgs.terraform
    pkgs.tflint
  ];
}
