{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/f84036f2b1d4dc61f57c3644e522d9610ee60e86";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              nil
              nixpkgs-fmt
              dprint
              actionlint
            ];
          };
      }
    );
}
