{
  description = "Webapp development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    devShells."${system}" = {
      base = pkgs.mkShell {
      packages = with pkgs; [
        git
        nodejs_20
        pnpm_8
        # nodePackages.pnpm
        #(yarn.override { nodejs = nodejs_18; })
        # Add nvm if needed
        # nvm
      ];

      # Environment variables
        shellHook = ''
          source ${./shells/base.sh}
        '';
    };      
      build = pkgs.mkShell {
      packages = with pkgs; [
        git
        nodejs_20
        pnpm_8
        # nodePackages.pnpm
        #(yarn.override { nodejs = nodejs_18; })
        # Add nvm if needed
        # nvm
      ];

      # Environment variables
        shellHook = ''
          source ${./shells/build.sh}
        '';
    };

    docker = pkgs.mkShell {
      packages = with pkgs; [
        git
        nodejs_20
        pnpm_8
        # nodePackages.pnpm
        #(yarn.override { nodejs = nodejs_18; })
        # Add nvm if needed
        # nvm
      ];

      # Environment variables
        shellHook = ''
          source ${./shells/docker.sh}
        '';
    };    
    };
  };
}