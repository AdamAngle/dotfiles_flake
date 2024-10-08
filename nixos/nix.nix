{ flake, pkgs, lib, ... }: {
  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
      # allowUnfreePredicate = _: true;
    };
    overlays = [
      flake.inputs.neovim-nightly-overlay.overlays.default
      (import ../packages {
        inherit flake;
        inherit (pkgs) system;
      })
    ];
  };

  nix = {
    package = pkgs.nixVersions.latest;
    nixPath = ["nixpkgs=${flake.inputs.nixpkgs}"]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    settings = {
      max-jobs = "auto";
      experimental-features = ["nix-command" "flakes"];
      # lol I don't plan to be using this on an Intel mac
      extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
      # Nullify the registry for purity.
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      trusted-users = [
        "root"
        (
          if pkgs.stdenv.isDarwin
          then flake.config.people.myself
          else "@wheel"
        )
      ];
    };
  };
}
