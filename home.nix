{ pkgs, currSys, ... }:

{
  home.username = "song";
  home.homeDirectory = if currSys == "aarch64-darwin" then "/Users/song" else "/home/song";
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.lepo

    pkgs.less
    pkgs.perl
    pkgs.jq
    pkgs.ncurses # clear, infocmp, tic
    pkgs.uutils-coreutils-noprefix # realpath
    pkgs.openssh
    pkgs.vim
    pkgs.neovim
    pkgs.curl
    pkgs.elinks

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

    pkgs.vscode-langservers-extracted # vscode-json-language-server
    pkgs.vscode-js-debug # js-debug
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
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "hoobira";
      custom = "$HOME/omz-custom";
    };
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
      SHELL = "${pkgs.zsh}/bin/zsh";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      VISUAL = "${pkgs.neovim}/bin/nvim";
    };
    envExtra = ''
      # Nix (Single user env prefered)
      if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
      elif [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi

      # Generate random key for sshd
      if [[ ! -f ~/.ssh/host_ed25519 ]]; then
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ~/.ssh/host_ed25519 -N ""
      fi
    '';
    initExtra = builtins.readFile ./zshrc;
    shellAliases = {
      grep = "grep --color=auto";
      l = "ls --color=auto --almost-all";
      la = "ls --color=auto --almost-all --long --human-readable";
      ls = "ls --color=auto";
      nd = ''
        ${pkgs.nix}/bin/nix develop --command env SHELL=${pkgs.zsh}/bin/zsh ${pkgs.neovim}/bin/nvim'';
      ns = ''
        ${pkgs.nix}/bin/nix-shell --run "SHELL=${pkgs.zsh}/bin/zsh ${pkgs.neovim}/bin/nvim"'';
      nz = ''
        ${pkgs.nix}/bin/nix develop --command env SHELL=${pkgs.zsh}/bin/zsh RPS1=" devShell" ${pkgs.zsh}/bin/zsh'';
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
