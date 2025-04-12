# The name of this theme, _hoobira_, means the _hoo_ mod of _bira_.
# This theme was inspired by _bira_, a built-in theme of _oh-my-zsh_.

local exitcode="%(?.○.●)"
local user="%{$fg[magenta]%}%n%{$reset_color%}"
local host="%{$fg_bold[red]%}%m%{$reset_color%}"
local cwd="%{$fg[blue]%}%~%{$reset_color%}"
local symbol='%(!.#.$)'

local git='$(git_prompt_info)$(git_prompt_status)$(git_prompt_remote)'

PROMPT="╭${exitcode} ${user}@${host}:${cwd}${git}
╰${symbol} "

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%} ±"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""

ZSH_THEME_GIT_PROMPT_AHEAD=" ↑"
ZSH_THEME_GIT_PROMPT_BEHIND=" ↓"

ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS=""
ZSH_THEME_GIT_PROMPT_REMOTE_MISSING=" ∅"
