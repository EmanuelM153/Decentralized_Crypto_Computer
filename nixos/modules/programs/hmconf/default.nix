{ lib, ... }:

{
  imports = [
    ./tmux.nix
    ./vim.nix
    ./zsh.nix
    ./git.nix
  ];

  git.enable = lib.mkDefault true;
}
