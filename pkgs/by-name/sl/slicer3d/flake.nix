{
  description = "Slicer3D dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      packages.x86_64-linux.Slicer3D = pkgs.callPackage ./package.nix {};
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          self.packages.x86_64-linux.Slicer3D
          pkgs.strace
          pkgs.ltrace
          pkgs.gdb
          pkgs.binutils
          pkgs.patchelf
          pkgs.file
          # pkgs.wirelesstools
          # pkgs.iw
          # pkgs.nettools
        ];
      };
    };
}
