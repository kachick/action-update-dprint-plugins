{
  inputs = {
    nixpkgs.url = "https://releases.nixos.org/nixpkgs/nixpkgs-23.11pre509148.9e06dd56947c/nixexprs.tar.xz";
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
