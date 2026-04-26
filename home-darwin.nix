{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  targets.darwin.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;
}
