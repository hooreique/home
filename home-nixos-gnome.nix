{ lib, de-pkgs, ... }:
let
  pkgs = de-pkgs;
in
{
  dconf.settings."org/gnome/desktop/background" = {
    picture-uri = "file://${./whvn-cc-ogj2v7.jpg}";
    picture-uri-dark = "file://${./whvn-cc-ogj2v7.jpg}";
    picture-options = "zoom";
  };

  dconf.settings."org/gnome/desktop/peripherals/keyboard" = {
    repeat = true;
    delay = lib.hm.gvariant.mkUint32 225;
    repeat-interval = lib.hm.gvariant.mkUint32 30;
  };

  dconf.settings."org/gnome/desktop/input-sources" = {
    xkb-options = [
      "caps:escape"
      "lv3:ralt_alt"
    ];
    sources = [
      (lib.hm.gvariant.mkTuple [
        "xkb"
        "us"
      ])
      (lib.hm.gvariant.mkTuple [
        "ibus"
        "lisle"
      ])
    ];
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-size = lib.hm.gvariant.mkInt32 48;
    font-antialiasing = "rgba";
  };

  dconf.settings."org/gnome/shell/extensions/hide-cursor-elcste-com".timeout = 15;

  dconf.settings."org/gnome/settings-daemon/plugins/power" = {
    idle-dim = false;
    sleep-inactive-ac-type = "nothing";
  };
  dconf.settings."org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 0;
  dconf.settings."org/gnome/desktop/screensaver".lock-enabled = false;

  dconf.settings."org/gnome/desktop/wm/keybindings".activate-window-menu =
    lib.hm.gvariant.mkEmptyArray lib.hm.gvariant.type.string;
  dconf.settings."org/gnome/desktop/wm/keybindings".cycle-windows =
    lib.hm.gvariant.mkEmptyArray lib.hm.gvariant.type.string;
  dconf.settings."org/gnome/desktop/wm/keybindings".move-to-center = [ "<Super>c" ];

  xdg.configFile."kanata/kanata.kbd".source = ./kanata.kbd;
  xdg.configFile."monitors.xml" = {
    source = ./monitors.xml;
    force = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  programs.zsh.shellAliases.p = "wl-paste";

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.clipboard-indicator; }
      { package = pkgs.gnomeExtensions.hide-cursor; }
      { package = pkgs.gnomeExtensions.pip-on-top; }
    ];
  };

  programs.ghostty = {
    package = pkgs.ghostty;
    enable = true;
    enableZshIntegration = false; # Resolves conflicting with p10k
  };

  programs.firefox = {
    package = pkgs.firefox;
    enable = true;
    profiles.default = {
      path = "k59pfcrl.default";
      settings."media.av1.enabled" = false;
      extensions.packages = [
        pkgs.nur.repos.rycee.firefox-addons.ublock-origin
      ];
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.chromium-spoofdpium;
    commandLineArgs = [
      "--accept-lang=ko-KR,ko,en-US,en"
      "--lang=ko"
    ];
    extensions = [
      # uBlock Origin Lite
      {
        id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
        crxPath = "${pkgs.fetchurl {
          url = "https://clients2.googleusercontent.com/crx/blobs/AZPVhcS_jEQr-NpRvwrJvCHv-B0OQ4wEEsb4PcN4h34C_F7sw24EEcUoAudWJIu6OgMeR18JuqfmUkL67Bhc3qd_kE1G5Mi1oAbm1SDMBL_OrgtMXcQ-UP-nJV4_LyBfGz_JAMZSmuUHBqaSiVJTxCtzrfZRwpgEyoo3Fg/DDKJIAHEJLHFCAFBDDMGIAHCPHECMPFH_2026_930_1227_0.crx";
          hash = "sha256-xQxWiobgAEck2A4wIRO6inWIeW2SBXUIxCg0Vgmqhfo=";
        }}";
        version = "2026.930.1227";
      }
      # Bitwarden Password Manager
      {
        id = "nngceckbapebfimnlniiiahkandclblb";
        crxPath = "${pkgs.fetchurl {
          url = "https://clients2.googleusercontent.com/crx/blobs/AZPVhcTSuzavwG_Z7DMpZaQNBEziLZX5-g8WUEH4QKYnQcbx1GX5fP1QnDlIq6yewF9BHV0E2Up5QfIKLqruICBEU0YOUmNxLT3Pohw9yNt0vbtjBJ0n0QGGIvgMEJBGLksOAMZSmuX_SjoLZ2eulWh81ewct5Th5yT-Uw/NNGCECKBAPEBFIMNLNIIIAHKANDCLBLB_2026_9_3_0.crx";
          hash = "sha256-mWT2YKEQI8sZpzC3+Qg1PsHa53oCfIGSMV0Kfz2O+SE=";
        }}";
        version = "2026.9.3";
      }
      # Simple Translate
      {
        id = "ibplnjkanclpjokhdolnendpplpjiace";
        crxPath = "${pkgs.fetchurl {
          url = "https://clients2.googleusercontent.com/crx/blobs/AZPVhcTkec_gmhEUNybDEIv38UUh1UtX72mOctuvVkKfI-i87W50bC0muPGktz7Q87Gy_jple11pwOIdRku2f5_TQvLvb0POKdssXoosCow-xwbpxrE0cW8iWA4DId9DaakAxlKa5cc7BNnmZvxi2Yuyz2lsnafPPnoU/IBPLNJKANCLPJOKHDOLNENDPPLPJIACE_3_1_0_0.crx";
          hash = "sha256-cC5FdeERprBc/zT66FtlkTW51/AsQ+gXRtixobw2IWg=";
        }}";
        version = "3.1.0";
      }
    ];
  };

  home.packages = [
    pkgs.soop
    pkgs.kanata
    pkgs.wl-clipboard
    pkgs.apostrophe
    pkgs.discord
    pkgs.spotify
    pkgs.netflix
  ];

  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard remapper";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "notify";
      ExecStart = "${pkgs.kanata}/bin/kanata --cfg %h/.config/kanata/kanata.kbd";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
