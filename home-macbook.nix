{ pkgs, ... }:

{
  home.packages = [ pkgs.macism ];

  programs.hisle.enable = true;

  targets.darwin.defaults = {
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    NSGlobalDomain.KeyRepeat = 2; # 2..120 (lower is faster)
    NSGlobalDomain.InitialKeyRepeat = 15; # 15..120 (lower is shorter)
    NSGlobalDomain."com.apple.sound.beep.feedback" = 1;
    "com.apple.HIToolbox".AppleFnUsageType = 2; # Show Emoji & Symbols
    "com.apple.WindowManager".EnableTiledWindowMargins = true;

    # Hot Corner bl, br to Mission Control
    "com.apple.dock".wvous-bl-corner = 2;
    "com.apple.dock".wvous-bl-modifier = 0;
    "com.apple.dock".wvous-br-corner = 2;
    "com.apple.dock".wvous-br-modifier = 0;
  };
}
