{ pkgs, ... }:

{
  home.packages = [
    # python
    pkgs.pipenv
    (
      pkgs.python38.withPackages
        (
          p: [
            p.black
            p.flake8
            p.mypy
            # p.poetry # disable: collision
            p.pylint
            p.virtualenv
          ]
        )
    )

    # js
    pkgs.hugo
    pkgs.nodejs
    pkgs.nodePackages.typescript
    pkgs.yarn

    # haskell
    # pkgs.ghc
    # pkgs.haskellPackages.haskell-language-server  # disable: circular dependency on arm64
    # pkgs.stack

    # rust
    pkgs.rustup

    # terraform
    pkgs.terraform
    pkgs.tflint
  ];
}
