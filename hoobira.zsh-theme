# The name of this theme, _hoobira_, means the _hoo_ mod of _bira_.
# This theme was inspired by _bira_, a built-in theme of _oh-my-zsh_.

local exitcode="%(?.○.●)"
local user="%{$fg[magenta]%}%n%{$reset_color%}"
local host="%{$fg_bold[red]%}%m%{$reset_color%}"
local cwd="%{$fg[blue]%}%~%{$reset_color%}"
local symbol='%(!.#.$)'

local git='$(git_prompt_info)$(git_prompt_status)$(git_prompt_remote)'

function set_prompt {
  PROMPT="╭${exitcode} ${user}@${host}:${cwd}${git}
╰${symbol} "
  RPROMPT='%(?..%B%F{1}%?%f%b)'
}

set_prompt

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%} ±"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""

ZSH_THEME_GIT_PROMPT_AHEAD=" ↑"
ZSH_THEME_GIT_PROMPT_BEHIND=" ↓"

ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS=""
ZSH_THEME_GIT_PROMPT_REMOTE_MISSING=" ∅"

# Transient Prompt Configuration
# Source: https://gist.github.com/subnut/3af65306fbecd35fe2dda81f59acf2b2

[[ -c /dev/null ]]  ||  return
zmodload zsh/system ||  return

TRANSIENT_PROMPT="%{$fg_bold[blue]%}${symbol}%{$reset_color%} "

typeset -g _transient_prompt_newline=
function _transient_prompt_set_prompt {
    set_prompt
    PROMPT='$_transient_prompt_newline'$PROMPT
}; _transient_prompt_set_prompt

zle -N clear-screen _transient_prompt_widget-clear-screen
function _transient_prompt_widget-clear-screen {
    _transient_prompt_newline=
    zle .clear-screen
}

zle -N send-break _transient_prompt_widget-send-break
function _transient_prompt_widget-send-break {
    _transient_prompt_widget-zle-line-finish
    zle .send-break
}

zle -N zle-line-finish _transient_prompt_widget-zle-line-finish
function _transient_prompt_widget-zle-line-finish {
    (( ! _transient_prompt_fd )) && {
        sysopen -r -o cloexec -u _transient_prompt_fd /dev/null
        zle -F $_transient_prompt_fd _transient_prompt_restore_prompt
    }
    zle && PROMPT=$TRANSIENT_PROMPT RPROMPT= zle reset-prompt && zle -R
}

function _transient_prompt_restore_prompt {
    exec {1}>&-
    (( ${+1} )) && zle -F $1
    _transient_prompt_fd=0
    _transient_prompt_set_prompt
    zle reset-prompt
    zle -R
}

(( ${+precmd_functions} )) || typeset -ga precmd_functions
(( ${#precmd_functions} )) || {
    do_nothing() {true}
    precmd_functions=(do_nothing)
}

precmd_functions+=_transient_prompt_precmd
function _transient_prompt_precmd {
    # We define _transient_prompt_precmd in this way because we don't want
    # _transient_prompt_newline to be defined on the very first precmd.
    TRAPINT() {zle && _transient_prompt_widget-zle-line-finish; return $(( 128 + $1 ))}
    function _transient_prompt_precmd {
        TRAPINT() {zle && _transient_prompt_widget-zle-line-finish; return $(( 128 + $1 ))}
        _transient_prompt_newline=$'\n'
    }
}
