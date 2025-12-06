{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell.override { stdenv = pkgs.clang19Stdenv; } {
          packages = [
            pkgs.bazel_7
            pkgs.bazel-buildtools
            # These go packages are just for VSCode / IDE
            # Bazel uses it's own Go toolchain declared in MODULE.bazel
            pkgs.go
            pkgs.gopls
            pkgs.delve
            # gRPC utilities
            pkgs.grpcurl
          ];
        };
      }
    );
}
