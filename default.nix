{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/f84036f2b1d4dc61f57c3644e522d9610ee60e86.tar.gz") { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.nil
    pkgs.nixpkgs-fmt
    pkgs.dprint
    pkgs.actionlint
  ];
}
