{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = [ pkgs.macism ];

  programs.hisle.enable = true;

  targets.darwin.defaults = {
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    NSGlobalDomain.KeyRepeat = 2; # 2..120 (lower is faster)
    NSGlobalDomain.InitialKeyRepeat = 15; # 15..120 (lower is shorter)
    "com.apple.HIToolbox".AppleFnUsageType = 2; # Show Emoji & Symbols
  };
}
