{ pkgs, system, username, ... }:

{
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ]; sandbox = "relaxed";
    };
  };

  home.username = username;
  home.homeDirectory = if system == "aarch64-darwin"
    then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # Dogfooding
    fall  lepo

    bash  openssh  lsof  less  gnused  perl  jq  curl  elinks  entr
    ncurses # clear, infocmp, tic
    uutils-coreutils-noprefix # cat, cp, mkdir ...
    zellij  eza
    vim  neovim

    # nix language server
    nil

    # for neovim
    gcc  ripgrep  lua-language-server

    # for nvim-treesitter
    tree-sitter  nodejs_22

    # for telescope
    gnumake  fd

    vscode-langservers-extracted # vscode-json-language-server
    vscode-js-debug # js-debug
    yaml-language-server
  ];

  home.file.".hushlogin".text = "";

  home.file."omz-custom/themes/hoobira.zsh-theme".source = ./hoobira.zsh-theme;

  xdg.configFile."zellij/config.kdl".source = ./zellij.${
    if system == "aarch64-darwin" then "mac" else "win"
  }.kdl;
  xdg.configFile."zellij/layouts/compact.kdl".text = ''
    layout {
      pane
      pane size=1 borderless=true {
        plugin location="compact-bar"
      }
    }
  '';

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
      enable = true; theme = "hoobira"; custom = "$HOME/omz-custom";
    };
    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
      SHELL = "${pkgs.zsh}/bin/zsh";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      VISUAL = "${pkgs.neovim}/bin/nvim";
      NVIM_APPNAME = "hoovim";
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
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
    initContent = builtins.readFile ./zshrc;
    shellAliases = {
      denv = ''nix develop --command env SHELL="${pkgs.zsh}/bin/zsh"'';
      gat = "GIT_PAGER=cat git";
      grep = "grep --color=auto";
      ls = "TERM=xterm ls --color=auto";
      l = "eza --almost-all --icons=auto --oneline";
      la = "eza --almost-all --long --icons=auto --time-style=iso";
      lc = "eza --almost-all --icons=auto";
      lt = ''eza --almost-all --long --icons=auto --time-style=iso --tree --level=2 --dereference --git --ignore-glob=".git|node_modules"'';
      lg = "lazygit";
      sj = "zellij";
      sn = "zellij --session";
      sa = "zellij attach";
      putil = ''fzf <<< "${builtins.readFile ./posix-utils.txt}"'';
    };
  };

  programs.fzf = { enable = true; enableZshIntegration = true; };

  programs.zoxide = { enable = true; enableZshIntegration = true; };

  programs.bat = {
    enable = true;
    config.theme = "sonokai";
    themes.sonokai = { src = ./sonokai; file = "tmtheme.xml"; };
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "yasi";
    settings.mgr = { show_hidden  = true; show_symlink = true; };
    keymap.mgr.prepend_keymap = [
      { on = "u" ; run = "arrow -1"  ; }  { on = "f" ; run = "arrow -3"   ; }
      { on = "e" ; run = "arrow 1"   ; }  { on = "s" ; run = "arrow 3"    ; }
      { on = "U" ; run = "arrow -9"  ; }  { on = "F" ; run = "arrow -50%" ; }
      { on = "E" ; run = "arrow 9"   ; }  { on = "S" ; run = "arrow 50%"  ; }
      { on = "n" ; run = "leave"     ; }  { on = "t" ; run = "open"       ; }
      { on = "i" ; run = "enter"     ; }  { on = "r" ; run = "cd ~"       ; }
      { on = "h" ; run = "arrow top" ; }  { on = "y" ; run = "seek 3"     ; }
      { on = "o" ; run = "arrow bot" ; }  { on = "l" ; run = "seek -3"    ; }
    ];
    flavors.sonokai    = ./sonokai;
    theme.flavor.dark  =  "sonokai";
    theme.flavor.light =  "sonokai";
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
      scrollHeight = 3; nerdFontsVersion = 3; filterMode = "fuzzy";
    };
  };
}
