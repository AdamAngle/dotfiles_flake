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

}
