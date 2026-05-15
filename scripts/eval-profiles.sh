#!/usr/bin/env bash
set -euo pipefail

targets=(
  darwinConfigurations.personalx86.config.system.build.toplevel.drvPath
  darwinConfigurations.personalArm64.config.system.build.toplevel.drvPath
  darwinConfigurations.personalArm64MacMini.config.system.build.toplevel.drvPath
  darwinConfigurations.canva.config.system.build.toplevel.drvPath
  homeConfigurations.personalx86.activationPackage.drvPath
  homeConfigurations.personalx86Linux.activationPackage.drvPath
  homeConfigurations.personalArm64.activationPackage.drvPath
  homeConfigurations.personalArm64MacMini.activationPackage.drvPath
  homeConfigurations.canva.activationPackage.drvPath
)

for target in "${targets[@]}"; do
  nix eval --raw ".#${target}" >/dev/null
done
