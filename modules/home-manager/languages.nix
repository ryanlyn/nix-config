{ pkgs, ... }:

{
  home.packages = [
    # python
    pkgs.pipenv
    pkgs.uv
    (pkgs.python311.withPackages (p: [
      # p.black # disable: broken python3.10-uvloop-0.16.0.drv dependency
      p.flake8
      p.mypy
      p.pip
      # p.poetry # disable: collision
      p.pylint
      p.virtualenv
    ]))

    # haskell
    pkgs.ghc
    # pkgs.haskellPackages.haskell-language-server  # disable: circular dependency on arm64
    pkgs.stack

    # rust
    pkgs.rustup

    # terraform
    pkgs.terraform
    pkgs.tflint
  ];
}
