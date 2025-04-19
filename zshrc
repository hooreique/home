unalias ll  2> /dev/null
unalias lsa 2> /dev/null

# Notify mac PATH pollution
if grep --quiet '^[[:space:]]*[^#]' /etc/zprofile 2> /dev/null; then
  echo "PATH: $PATH

You might want to sudo --edit /etc/zprofile"
fi

nman() {
  if [ $# -ne 1 ]; then
    echo "Usage: nman <entry>" >&2
    return 1
  fi

  if [[ ! "$1" =~ "^[-._()0-9a-zA-Z]+$" ]]; then
    echo "Invalid entry name: $1" >&2
    return 1
  fi

  if man --where "$1" >/dev/null 2>&1; then
    nvim +"Man $1 | wincmd w | bdelete"
  else
    echo "Entry not found: $1" >&2
    return 1
  fi
}

# Run extra rc
if [[ -f ~/init.zsh ]]; then
  source ~/init.zsh
fi
