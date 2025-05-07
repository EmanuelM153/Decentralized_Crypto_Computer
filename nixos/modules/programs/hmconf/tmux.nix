{
  pkgs,
  ...
}:

{
  config = {
    programs.tmux = {
      enable = true;
      escapeTime = 10;
      mouse = true;
      keyMode = "vi";
      prefix = "C-j";
      terminal = "xterm-256color";
      shell = "${pkgs.zsh}/bin/zsh";
      tmuxp.enable = true;
      extraConfig = ''
        set -g status-right "#[bg=colour252,fg=colour243,nobold,nounderscore,noitalics]#[bg=colour243,fg=colour255] #(ip addr | grep -e 'state UP' -A 3 | awk '/inet /{printf $2 \"  \"}' | sed 's/  $//g') #[bg=colour243,fg=colour237,nobold,noitalics,nounderscore]#[bg=colour237,fg=colour255] #h "
      '';
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.pain-control;
        }
        {
          plugin = tmuxPlugins.gruvbox;
          extraConfig = ''
            set -g @tmux-gruvbox "light"
          '';
        }
      ];
    };
  };
}
