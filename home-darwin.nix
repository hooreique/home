{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  targets.darwin.defaults = {
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    NSGlobalDomain.KeyRepeat = 2; # 2..120 (lower is faster)
    NSGlobalDomain.InitialKeyRepeat = 15; # 15..120 (lower is shorter)
    "com.apple.HIToolbox".AppleFnUsageType = 2; # Show Emoji & Symbols
    "com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
      # Keyboard Shortcuts > Input Sources > Select the previous input source: F19
      "60" = { enabled = true; value.type = "standard"; value.parameters = [ 65535 80 8388608 ]; };
      # Keyboard Shortcuts > Input Sources > Select next source in Input menu: F18
      "61" = { enabled = true; value.type = "standard"; value.parameters = [ 65535 79 8388608 ]; };
    };
  };
}
