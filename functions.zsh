c() {
  printf '\033]52;c;%s\007' "$(base64 | tr --delete '\n')"
}

diffless() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: diffless <file1> <file2>" >&2
    return 1
  fi

  diff --color=always --unified "$1" "$2" | less
}

hman() {
  if [ $# -ne 1 ]; then
    echo "Usage: hman <entry>" >&2
    return 1
  fi

  if [[ ! "$1" =~ "^[-._()0-9a-zA-Z]+$" ]]; then
    echo "Invalid entry name: $1" >&2
    return 1
  fi

  if man --where "$1" >/dev/null 2>&1; then
    hvim +"Man $1 | wincmd w | bdelete"
  else
    echo "Entry not found: $1" >&2
    return 1
  fi
}
