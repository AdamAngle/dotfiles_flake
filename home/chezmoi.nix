{ pkgs, config, lib, ... }:
let
  homeDir = config.home.homeDirectory;
in {
  home.packages = with pkgs; [
    chezmoi
  ];
}
