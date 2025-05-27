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
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Dogfooding
    fall  nide  lepo

    less  perl  jq  curl
    ncurses # clear, infocmp, tic
    uutils-coreutils-noprefix # cat, cp, mkdir ...
    openssh  zellij  eza  elinks
    vim  neovim

    # nix language server
    nil

    # for neovim
    gcc  ripgrep  lua-language-server

    # for nvim-treesitter
    tree-sitter  nodejs_22

    # for telescope
    gnumake  fd

    # for mason.nvim (<- nvim-java)
    wget  unzip

    vscode-langservers-extracted # vscode-json-language-server
    vscode-js-debug # js-debug
  ];

  home.file.".hushlogin".text = "";

  home.file."omz-custom/themes/hoobira.zsh-theme".source = ./hoobira.zsh-theme;

  xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
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
    initExtra = builtins.readFile ./zshrc;
    shellAliases = {
      nide = "nide env SHELL=${pkgs.zsh}/bin/zsh";
      grep = "grep --color=auto";
      ls = "ls --color=auto";
      l = "eza --almost-all --icons=auto --oneline";
      la = "eza --almost-all --long --icons=auto --time-style=iso";
      lc = "eza --almost-all --icons=auto";
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
    settings.manager = { show_hidden  = true; show_symlink = true; };
    keymap.manager.prepend_keymap = [
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
