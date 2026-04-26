## Bootstrap

```sh
mkdir -p ~/.config/home-manager
nix run nixpkgs#git -- clone https://github.com/hooreique/home.git ~/.config/home-manager
nix run nixpkgs#home-manager -- switch
```

## Things to Remember

- `~/.ssh/id_ed25519` is used for SSH and Git commit signing.
- `~/init.zsh` is sourced when present; keep host-local hacks there.
- Zellij config switches by platform: `zellij.mac.kdl` on Darwin, `zellij.win.kdl` elsewhere.
- On WSL, keep `/etc/wsl.conf` with `appendWindowsPath=false`. See https://learn.microsoft.com/en-us/windows/wsl/wsl-config#interop-settings
