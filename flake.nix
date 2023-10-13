{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
    sbt.url = "github:zaninime/sbt-derivation";
    sbt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, utils, sbt }:
  utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.default = pkgs.mkShell {
      buildInputs = [pkgs.sbt pkgs.metals pkgs.hello];
    };

    packages.default = sbt.mkSbtDerivation.${system} {
      pname = "nix-scala-example";
      version = "0.1.0";
      depsSha256 = "sha256-Vh0WCGEexw8aHt+cLYUgEnpH7NZY+naxj7lTSonsjyM=";

      src = ./.;

      buildInputs = [pkgs.sbt pkgs.jdk17_headless pkgs.makeWrapper];

      buildPhase = "sbt assembly";

      installPhase = ''
          mkdir -p $out/bin
          mkdir -p $out/share/java

          cp target/scala-2.13/*.jar $out/share/java

          makeWrapper ${pkgs.jdk17_headless}/bin/java $out/bin/nix-scala-example \
            --add-flags "-cp \"$out/share/java/*\" com.example.nixscalaexample.Main"
      '';
    };
  });
}
