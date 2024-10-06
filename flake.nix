{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      commonArgs = {
        npmDeps = pkgs.importNpmLock {
          npmRoot = pkgs.lib.sourceFilesBySuffices ./. ["package.json" "package-lock.json"];
        };
        src = pkgs.lib.sourceFilesBySuffices ./. [".ts" ".json"];
        npmConfigHook = pkgs.importNpmLock.npmConfigHook;
      };

      agent = pkgs.buildNpmPackage (commonArgs
        // {
          name = "agent";
          installPhase = ''
            cp _agent.js $out
          '';
        });

      modules = pkgs.buildNpmPackage (commonArgs
        // {
          name = "modules";
          npmBuildHook = "";
          installPhase = ''
            cp -r node_modules $out
          '';
        });
    in {
      packages = {
        inherit agent modules;
        default = agent;
      };

      devShell = pkgs.mkShell {
        packages = [
          pkgs.nodejs
        ];

        NODE_PATH = "${modules}";
      };
    });
}
