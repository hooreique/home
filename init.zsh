# Nix (Single user env prefered)
if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
  source ~/.nix-profile/etc/profile.d/nix.sh
elif [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# Generate random key for SSHD
if [[ ! -f ~/.ssh/host_ed25519 ]]; then
  ssh-keygen -t ed25519 -f ~/.ssh/host_ed25519 -N ""
fi

# Run extra mutable profile
if [[ -f ~/profile.zsh ]]; then
  source ~/profile.zsh
fi
