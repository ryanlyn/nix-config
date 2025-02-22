{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell rec {
  name = "python-env";
  LD_LIBRARY_PATH = lib.makeLibraryPath [ gcc-unwrapped zlib libglvnd glib ];
  buildInputs = [ python310 python310Packages.pip git ];
}
