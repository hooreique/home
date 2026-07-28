{ pkgs, lib, my-pkgs, ... }:

{
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
      (lib.hm.gvariant.mkTuple [ "ibus" "lisle" ])
      (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
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

  dconf.settings."org/gnome/desktop/wm/keybindings".activate-window-menu = lib.hm.gvariant.mkEmptyArray lib.hm.gvariant.type.string;

  xdg.configFile."kanata/kanata.kbd".source = ./kanata.kbd;
  xdg.configFile."monitors.xml" = {
    source = ./monitors.xml;
    force = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html"              = "firefox.desktop";
      "application/xhtml+xml"  = "firefox.desktop";
      "x-scheme-handler/http"  = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-14 days";
    frequency = "Sun *-*-* 02:30:00";
    store.cleanup = false;
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.clipboard-indicator; }
      { package = pkgs.gnomeExtensions.hide-cursor; }
    ];
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = false; # Resolves conflicting with p10k
  };

  programs.firefox = {
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
          url = "https://clients2.googleusercontent.com/crx/blobs/AUU14H-WmxygTsxFFOV3oB5ij3tfrKJefDYhM7YeHo4ieGynOkNZEoxTw72rOYH51nig7YBtUUlCXiOG2hc0Q5um8biI9JiV145LnsOu0elBTGjoPBMw7hrcGgV50yeXNGu2AMZSmuWLcH11QFEbn72Fw4tz4q-m9I81nw/DDKJIAHEJLHFCAFBDDMGIAHCPHECMPFH_2026_812_1211_0.crx";
          hash = "sha256-QjPIOwUbfw6Is8GiL+FjiPECqg0ThT/csEViJH4E1W0=";
        }}";
        version = "2026.812.1211";
      }
      # Bitwarden Password Manager
      {
        id = "nngceckbapebfimnlniiiahkandclblb";
        crxPath = "${pkgs.fetchurl {
          url = "https://clients2.googleusercontent.com/crx/blobs/AUU14H_5IIKPKCTo6luRPoQog1QUSEn4OTriGfnBophN5DxJE4kMTZaClPMtVEpqmfCBIwJyTVHp9Y0ug82wHqSAkZVhr_YmMjW9qBrcC6Kr2cYpMrDE9IiBgbAyhRJvvn0aAMZSmuUN9detRDreGc88UECnTh_RMFEeOQ/NNGCECKBAPEBFIMNLNIIIAHKANDCLBLB_2026_7_0_0.crx";
          hash = "sha256-PwXLkgGS9YjvBRUHgwiEtqiXkXmWngv3xA4Boqj9f74=";
        }}";
        version = "2026.7.0";
      }
      # Simple Translate
      {
        id = "ibplnjkanclpjokhdolnendpplpjiace";
        crxPath = "${pkgs.fetchurl {
          url = "https://clients2.googleusercontent.com/crx/blobs/Abe5cL5VAwjUtEDkoNuE97yMAph5ktxjd8YHxtG06iViyxItSkTLe_IO9orC1oCogiIki1YsV2ABlHCrTF2OEaTGGd2UfrxzSqVrWuiEu1mJLrmJ9sDtyTW9VYBnlrp3zFgAxlKa5WBr9x_Lk-kAmCmvJ9ZuW1-zpeuF/IBPLNJKANCLPJOKHDOLNENDPPLPJIACE_3_0_1_0.crx";
          hash = "sha256-7UcRpnNSiqfTm9te7CYQahgF+zubILXYznqUuYontlM=";
        }}";
        version = "3.0.1";
      }
    ];
  };

  home.packages = [
    my-pkgs.soop
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
