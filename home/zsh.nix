{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      if [ -f $HOME/.config/zsh/zshrc ]; then
        source $HOME/.config/zsh/zshrc
      fi
    '';
  };
}
