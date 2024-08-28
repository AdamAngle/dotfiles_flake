{
  self,
  flake,
  config,
  nixpkgs,
  ...
}: {
  # Configuration common to all Linux systems
  flake = {
    
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./system
      ];
    };

#    nixosConfigurations.nixos = withSystem "x86_64-linux" ({pkgs, system}:
#      nixpkgs.lib.nixosSystem {
#        inherit system;
#        modules = [
#          ./system
#        ] ++ shared;
#        specialArgs = {
#          inherit inputs pkgs;
#        };
#      }
#    );

    nixosModules = {
      # NixOS modules that are known to work on nix-darwin.
      common.imports = [
        ./nix.nix
      ];

      my-home = {
        users.users.${config.people.myself}.isNormalUser = true;
        home-manager.users.${config.people.myself} = {
          imports = [
          ];
        };
      };

      default.imports = [
        self.nixosModules.home-manager
        self.nixosModules.my-home
        self.nixosModules.common
        ./ssh-auth.nix
      ];
    };
  };
}
