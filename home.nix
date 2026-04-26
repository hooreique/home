{ config, pkgs, system, username, ... }:

{
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      sandbox = "relaxed";

      extra-substituters = [
        "https://hooreique.cachix.org"
        "https://cache.numtide.com"
      ];
      extra-trusted-public-keys = [
        "hooreique.cachix.org-1:xuPFUhHZkm48tim3zma5/v67Fag5vn8XLBXLiYYeXOE="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };

  home.username = username;
  home.homeDirectory = if system == "aarch64-darwin"
    then "/Users/${username}" else "/home/${username}";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # Dogfooding
    fall

    nushell
    bash  lsof  less  gnused  perl  jq  entr
    openssh  openssl  curl  elinks
    dig                       # nslookup
    inetutils                 # telnet
    diffutils                 # cmp
    ncurses                   # clear, infocmp, tic
    uutils-coreutils          # uutils-env
    uutils-coreutils-noprefix # cat, cp, mkdir
    uutils-findutils          # find
    unixtools.watch
    zellij  eza  difftastic
    vim  neovim

    # nix language server
    nil

    # for neovim
    gcc  ripgrep  lua-language-server

    # for nvim-treesitter
    tree-sitter  nodejs_24

    # for telescope
    gnumake  fd

    vscode-langservers-extracted # vscode-json-language-server
    vscode-js-debug # js-debug
    yaml-language-server
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "${pkgs.neovim}/bin/nvim";
    VISUAL = "${pkgs.neovim}/bin/nvim";
    NVIM_APPNAME = "hoovim";
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };

  home.file.".hushlogin".text = "";

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

  xdg.enable = true;

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      identityFile = "~/.ssh/id_ed25519";
      serverAliveInterval = 60;
      serverAliveCountMax = 3;
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";  src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    envExtra = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi

      # Generate random key for sshd
      if [[ ! -f ~/.ssh/host_ed25519 ]]; then
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ~/.ssh/host_ed25519 -N ""
      fi
    '';
    initContent = ''
      source ${./functions.zsh}

      # Unalias unwanted zsh builtin ls alias
      unalias ls  2> /dev/null
      unalias ll  2> /dev/null
      unalias lsa 2> /dev/null

      # Run extra rc
      if [[ -f ~/init.zsh ]]; then
        source ~/init.zsh
      fi

      source ${./p10k.zsh}
    '';
    shellAliases = {
      denv = ''nix develop --command -- "${pkgs.uutils-coreutils}/bin/uutils-env" SHELL="${pkgs.zsh}/bin/zsh"'';
      uenv = ''NIXPKGS_ALLOW_UNFREE=1 nix develop --impure --command -- "${pkgs.uutils-coreutils}/bin/uutils-env" SHELL="${pkgs.zsh}/bin/zsh"'';
      gat = "GIT_PAGER=cat git";
      gafft = "GIT_PAGER=cat GIT_EXTERNAL_DIFF=${pkgs.difftastic}/bin/difft git diff";
      gifft = "GIT_EXTERNAL_DIFF=${pkgs.difftastic}/bin/difft git diff";
      grep = "/usr/bin/grep --color=auto";
      ls = ''"${pkgs.uutils-coreutils}/bin/uutils-ls" --color=auto'';
      l = "eza --almost-all --icons=auto --oneline";
      la = "eza --almost-all --long --icons=auto --time-style=iso";
      lc = "eza --almost-all --icons=auto";
      lt = ''eza --almost-all --long --icons=auto --time-style=iso --tree --level=2 --dereference --git --ignore-glob=".git|node_modules"'';
      sj = "zellij";
      sn = "zellij --session";
      sa = "zellij attach";
      p = "/usr/bin/pbpaste";
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
    settings = {
      user.name           = "Song Jeyeong";
      user.email          = "46372718+hooreique@users.noreply.github.com";
      user.signingKey     = "~/.ssh/id_ed25519";
      gpg.format          = "ssh";
      gpg.ssh.program     = "${pkgs.openssh}/bin/ssh-keygen";
      commit.gpgSign      = true;
      rerere.enabled      = true;
      diff.tool           = "neovim";
      difftool.neovim.cmd = ''${pkgs.neovim}/bin/nvim -d "$LOCAL" "$REMOTE"'';
    };
  };

  programs.lazygit = {
    enable = true;
    settings.gui = {
      scrollHeight = 3; nerdFontsVersion = "3"; filterMode = "fuzzy";
    };
    settings.git.overrideGpg = true;
    settings.git.pagers = [{ externalDiffCommand = "${pkgs.difftastic}/bin/difft --color=always --display=inline"; }];
  };
}
