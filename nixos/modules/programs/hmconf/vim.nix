{ pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      nnoremap <C-a> o<Esc>k
      nnoremap <C-s> O<Esc>j
      let &t_SI = "\e[6 q"
      let &t_EI = "\e[2 q"

      highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
      autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
      match ExtraWhitespace /\s\+$/
      autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
      autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
      autocmd InsertLeave * match ExtraWhitespace /\s\+$/
      autocmd BufWinLeave * call clearmatches()
    '';
    settings = {
      hidden = true;
      expandtab = true;
      copyindent = true;
      relativenumber = true;
    };
    plugins = with pkgs; [
      vimPlugins.vim-sensible
    ];
  };
}
