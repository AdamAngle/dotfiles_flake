{pkgs, ...}: {
  home.packages = with pkgs; [
    tmux
    (writeShellScriptBin "tma" ''
       #
       # tmuxa
       #
       # Tmux create new session or attach
       #
      ${pkgs.tmux}/bin/tmux attach || ${pkgs.tmux}/bin/tmux
    '')
  ];
}
