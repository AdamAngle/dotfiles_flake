{ self, flake, inputs, ... }: {

  flake = {
    homeModules = {
      common = {
        home.stateVersion = "24.05";
        imports = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.nix-index-database.hmModules.nix-index
          ./chezmoi.nix
          #./neovim.nix
          #./git.nix
          #./tmux.nix
          #./zsh.nix
          #./fonts.nix
        ];
      };
    };
  };

}

