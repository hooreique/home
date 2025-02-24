{ pkgs, currSys, ... }:

{
  home.username = "song";
  home.homeDirectory = if currSys == "aarch64-darwin" then "/Users/song" else "/home/song";
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.ncurses
    pkgs.uutils-coreutils-noprefix
    pkgs.openssh
    pkgs.gh
    pkgs.vim
    pkgs.neovim
    pkgs.gnused
    pkgs.perl
    pkgs.lsof

    # nix language server
    pkgs.nil

    # for neovim
    pkgs.gcc
    pkgs.ripgrep
    pkgs.lua-language-server

    # for nvim-treesitter
    pkgs.tree-sitter
    pkgs.nodejs_22

    # for telescope
    pkgs.gnumake
    pkgs.fd

    # for mason.nvim (<- nvim-java)
    pkgs.wget
    pkgs.unzip

    pkgs.vscode-langservers-extracted
    pkgs.vscode-js-debug
  ];

  home.file.".hushlogin".text = "";

  home.file."omz-custom/themes/hoobira.zsh-theme".source = ./hoobira.zsh-theme;

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    serverAliveInterval = 60;
    serverAliveCountMax = 3;
    matchBlocks."*".identityFile = "~/.ssh/id_ed25519";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    profileExtra = builtins.readFile ./init.zsh;
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
      SHELL = "${pkgs.zsh}/bin/zsh";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      VISUAL = "${pkgs.neovim}/bin/nvim";
    };
    shellAliases = {
      nd = "${pkgs.nix}/bin/nix develop --command env SHELL=${pkgs.zsh}/bin/zsh ${pkgs.neovim}/bin/nvim";
      ns = "${pkgs.nix}/bin/nix-shell --run 'SHELL=${pkgs.zsh}/bin/zsh ${pkgs.neovim}/bin/nvim'";
    };
    oh-my-zsh = {
      enable = true;
      theme = "hoobira";
      plugins = [ "git" ];
      custom = "$HOME/omz-custom";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Song Jeyeong";
    userEmail = "46372718+hooreique@users.noreply.github.com";
    extraConfig = {
      user.signingKey = "~/.ssh/id_ed25519";
      gpg.format = "ssh";
      commit.gpgSign = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings.gui = {
      scrollHeight = 3;
      nerdFontsVersion = 3;
      filterMode = "fuzzy";
    };
  };
}
