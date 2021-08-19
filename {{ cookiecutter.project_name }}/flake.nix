{
  description = "";
  nixConfig.bash_prompt = "% ";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pybit-src = {
      url = "github:verata-veritatis/pybit";
      flake = false;
    };
    websocket-client-src = {
      url = "github:websocket-client/websocket-client";
      flake = false;
    };
  };

  outputs = inputs @ { nixpkgs, flake-utils, pybit-src, websocket-client-src, self }:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        pkgs = import nixpkgs { inherit system; overlays = [
          (final: prev: {
            python = prev.python.override {
              packageOverrides = (pyfinal: pyprev: {
                websocket-client = pyprev.buildPythonPackage rec {
                  pname = "websocket-client";
                  version = "1.2.1";
                  src = websocket-client-src;
                };
              });
            };
          })
        ]; };
        pybit = pkgs.python3Packages.buildPythonPackage {
          pname = "pybit";
          version = "1.2.0";
          src = pybit-src;
          buildInputs = with pkgs.python3Packages; [ requests websockets websocket-client ];
          propagatedBuildInputs = with pkgs.python3Packages; [ requests websockets websocket-client ];
          doCheck = false;
          meta = with pkgs.lib; {
            homepage = "https://github.com/verata-veritatis/pybit";
            description = "Python3 API connector for Bybit's HTTP and Websockets APIs.";
            license = licenses.mit;
          };
        };
      in {

        defaultPackage = pybit;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ ipython pybit requests websockets websocket-client ];
          shellHook = ''
            echo "Hello.. here I am :=)"
          '';
        };
      }
    );
}