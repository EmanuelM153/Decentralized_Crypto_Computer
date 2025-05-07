{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    historySubstringSearch.enable = true;

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "brackets" ];
    };

    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
      "~" = "cd ~";
      la = "ls -a";
      py = "python3";
      rmgit = "yes | rm -r";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];

    initContent = ''
      if [ "$TMUX" = "" ]; then tmux; fi
      REPORTTIME=10
    '';

    oh-my-zsh = {
      enable = true;
      theme = "gentoo";
      plugins = [
        "extract"
        "gitfast"
        "git"
        "colored-man-pages"
        "systemd"
      ];
    };
  };
}
