{
  description = "NordVPN package flake (nixos-25.05)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        libtelioOverlay = final: prev: {
          libtelio = import ../../li/libtelio/package.nix {
            inherit (final) stdenv fetchFromGitHub lib rustPlatform;
          };
        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ libtelioOverlay ];
        };
      in
      {
        packages.default = pkgs.callPackage ./package.nix { };
        devShells.default = pkgs.mkShell { };
      }
    );
}
