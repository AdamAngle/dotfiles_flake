{
  description = "Jasmine's Nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nixos-flake.url = "github:srid/nixos-flake";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    
    # Tools
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {

#      nixosConfiguration.nixos = nixpkgs.lib.nixosSystem {
#        system = "x86_64-linux";
#        modules = [ ./system/configuration.nix ];
#      };

      systems = ["x86_64-linux"];
      imports = [
        inputs.nixos-flake.flakeModule
        ./nixos
        ./home
        ./config
      ];   
    };
    
    perSystem = {
        self,
        system,
        pkgs,
        lib,
        config,
        inputs,
        ...
      }: {
        nixos-flake.primary-inputs = ["nixpkgs" "home-manager" "nixos-flake"];

        devShells.default = pkgs.mkShell {
          name = "dotfiles_flake";
          nativeBuildInputs = [
            config.treefmt.build.wrapper
          ];
          packages = [
            pkgs.sops
            pkgs.ssh-to-age
            pkgs.alejandra
          ];
          DIRENV_LOG_FORMAT = "";
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        pre-commit = {
          settings.excludes = ["flake.lock"];
          settings.hooks = {
            treefmt.enable = true;
          };
        };

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs.alejandra.enable = true;
        };

        formatter = config.treefmt.build.wrapper;
        packages = let
          allpkgs = pkgs.symlinkJoin {
            name = "all";
            paths = [
              self.packages.activate
              self.packages.nix-cleanup
              self.packages.nixos-cleanup
            ];
          };
        in {
          default = allpkgs;
          activate = self.packages.activate;
          nix-cleanup = self.packages.nix-cleanup;
          nixos-cleanup = self.packages.nixos-cleanup;
          all = allpkgs;
        };

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (import ./packages {
              flake = self;
              inherit (pkgs) system;
            })
          ];
          config = {};
        };
      };
}
