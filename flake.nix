{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    wordwarvi_src.url = "https://master.dl.sourceforge.net/project/wordwarvi/wordwarvi/wordwarvi-1.00/wordwarvi-1.00.tar.gz";
    wordwarvi_src.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, wordwarvi_src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = wordwarvi;

          wordwarvi = pkgs.stdenv.mkDerivation rec {
            pname = "wordwarvi";
            version = "1.0.0";

            src = wordwarvi_src;

            postPatch = ''
              substituteInPlace Makefile \
                --replace "/bin/rm" "rm"
            '';

            buildPhase = ''
              make PREFIX=$out
            '';

            installPhase = ''
              make install PREFIX=$out
            '';

            nativeBuildInputs = with pkgs; [
              pkg-config
            ];

            buildInputs = with pkgs; [
              libvorbis
              portaudio
              gtk2
            ];
          };
        };
      }
    );
}
