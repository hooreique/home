{ config, pkgs, my-pkgs, ... }:

{
  home.stateVersion = "26.11";

  home.packages = with pkgs; [
    # Dogfooding
    my-pkgs.fall  my-pkgs.hvim  my-pkgs.saseo

    bash  man  lsof  less  gnused  perl  jq  entr
    openssh  openssl  curl
    dig                       # nslookup
    inetutils                 # telnet
    diffutils                 # cmp
    ncurses                   # clear, infocmp, tic
    uutils-coreutils          # uutils-env
    uutils-coreutils-noprefix # cat, cp, mkdir
    uutils-findutils          # find
    unixtools.watch
    eza  zellij
    vim  neovim
    fd  ripgrep
    delta  difftastic
    nushell
  ];

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    SHELL = "${pkgs.zsh}/bin/zsh";
    EDITOR = "${my-pkgs.hvim}/bin/hvim";
    VISUAL = "${my-pkgs.hvim}/bin/hvim";
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };

  home.file.".hushlogin".text = "";

  xdg.configFile."zellij/config.kdl".source = ./zellij.${
    if pkgs.stdenv.isDarwin then "mac" else "win"
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
    settings."*" = {
      IdentityFile = "~/.ssh/id_ed25519";
      ServerAliveInterval = 60;
      ServerAliveCountMax = 3;
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    fastSyntaxHighlighting.enable = true;
    oh-my-zsh.enable = true;
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
      galta = ''GIT_PAGER="${pkgs.delta}/bin/delta --paging=never" git diff'';
      gelta = "GIT_PAGER=${pkgs.delta}/bin/delta git diff";
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
      se = "zellij action edit-scrollback";
      sd = "zellij action dump-screen";
      ss = "zellij action dump-screen --full";
      p = "/usr/bin/pbpaste";
      putil = ''fzf <<< "${builtins.readFile ./posix-utils.txt}"'';
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # fzf 와 atuin 이 Ctrl-R 을 동시에 바인딩하므로, atuin이 소유하도록 fzf 바인딩 해제
    historyWidget.zsh.command = "";
  };

  programs.atuin = { enable = true; enableZshIntegration = true; };

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
      user.name         = "Song Jeyeong";
      user.email        = "46372718+hooreique@users.noreply.github.com";
      user.signingKey   = "~/.ssh/id_ed25519";
      gpg.format        = "ssh";
      gpg.ssh.program   = "${pkgs.openssh}/bin/ssh-keygen";
      commit.gpgSign    = true;
      rerere.enabled    = true;
      diff.tool         = "hvim";
      difftool.hvim.cmd = ''${my-pkgs.hvim}/bin/hvim -d "$LOCAL" "$REMOTE"'';
    };
    settings.delta = {
      syntax-theme = "sonokai";
      line-numbers = true;
      line-numbers-left-style  = "#5a6477";  line-numbers-minus-style = "#ff6578";
      line-numbers-right-style = "#5a6477";  line-numbers-plus-style  = "#9dd274";
      line-numbers-zero-style  = "#5a6477";
      minus-style      = ''syntax "#3d343a"'';  plus-style      = ''syntax "#313936"'';
      minus-emph-style = ''syntax "#55393d"'';  plus-emph-style = ''syntax "#394634"'';
      commit-style = "bold #ba9cf3";
      file-style = "bold #72cce8";
      file-decoration-style = "#424b5b ul";
      hunk-header-style = "file line-number syntax";
      hunk-header-decoration-style = "none";
      hunk-header-file-style = "#72cce8";
      hunk-header-line-number-style = "#ba9cf3";
    };
  };

  programs.lazygit = {
    enable = true;
    settings.git.overrideGpg = true;
    settings.git.pagers = [{ pager = "${pkgs.delta}/bin/delta --paging=never"; }];
    settings.gui = {
      scrollHeight = 3; nerdFontsVersion = "3"; filterMode = "fuzzy";
    };
  };
}
