unalias grep 2> /dev/null
unalias ls 2> /dev/null

# To find process by port
pp() {
  ss --tcp --ipv4 --listening --processes --no-header --no-queues \
    | grep --perl-regexp :$1\\s \
    | grep --only-matching --perl-regexp 'pid=\K[0-9]+'
}

# Run extra rc
if [[ -f ~/init.zsh ]]; then
  source ~/init.zsh
fi
