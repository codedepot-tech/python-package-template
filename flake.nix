{
  description = "";
  nixConfig.bash_prompt = "% ";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = "github:nix-community/poetry2nix";
  };

  outputs = inputs @ { nixpkgs, flake-utils, poetry2nix, self }:
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
        pkgs = import nixpkgs;
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
        poetry2nix-env = poetry2nix.mkPoetryEnv {
          projectDir = ./.;
          editablePackageSources = {
            {{cookiecutter.project_name}} = ./.;
          };
        };
      in {

        devShell = poetry2nix-env.env;

        };
      }
    );
}