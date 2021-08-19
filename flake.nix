{
  description = "";
  nixConfig.bash_prompt = "% ";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ { nixpkgs, flake-utils, self }:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        # pkgs = import nixpkgs { inherit system; overlays = [
        #   (final: prev: {
        #     python = prev.python.override {
        #       packageOverrides = (pyfinal: pyprev: {
        #         websocket-client = pyprev.buildPythonPackage rec {
        #           pname = "websocket-client";
        #           version = "1.2.1";
        #           src = websocket-client-src;
        #         };
        #       });
        #     };
        #   })
        # ]; };
        pkgs = import nixpkgs { inherit system; };
        # pybit = pkgs.python3Packages.buildPythonPackage {
        #   pname = "pybit";
        #   version = "1.2.0";
        #   src = pybit-src;
        #   buildInputs = with pkgs.python3Packages; [ cookiecutter ];
        #   propagatedBuildInputs = with pkgs.python3Packages; [ cookiecutter ];
        #   doCheck = false;
        #   meta = with pkgs.lib; {
        #     homepage = "https://github.com/verata-veritatis/pybit";
        #     description = "Python3 API connector for Bybit's HTTP and Websockets APIs.";
        #     license = licenses.mit;
        #   };
        # };
        # poetry2nix-env = pkgs.poetry2nix.mkPoetryEnv {
        #   python = pkgs.python38;
        #   projectDir = ./.;
        #   editablePackageSources = {
        #     python-package-template = ./.;
        #   };
        # };
      in {

        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.cookiecutter ];
          shellHook = ''
            export PS1="% ";
          '';
        };

        }
    );
}