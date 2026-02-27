# Imports #####################################################################

## Autoloads
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
  compinit
else
  compinit -C
fi

## My stuff
source ~/.zsh/.path
source ~/.zsh/.aliases
source ~/.zsh/.functions

## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q ' \
    zsh-users/zsh-completions

zinit wait lucid light-mode for \
  OMZP::colored-man-pages \
  OMZP::dircycle \
  OMZP::git \
  OMZP::sudo \
  nocttuam/autodotenv \
  zpm-zsh/colorize \
  zpm-zsh/colors \
  zsh-users/zsh-history-substring-search

# Configuration ###############################################################

# http://zsh.sourceforge.net/Doc/Release/Options.html
setopt ALWAYS_TO_END        # Move cursor to the end of a word when completed
setopt AUTO_CD              # Try cd if the command isn't understood
setopt AUTO_MENU            # Use menu completion after the second consecutive request for completion
setopt CORRECT              # Enable correction
setopt CORRECT_ALL          # Enable correction
setopt INTERACTIVE_COMMENTS # Allow interactive shell comments
unsetopt CASE_GLOB          # Case-insensitive globbing

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' # Case-insensitive path completion
zstyle ':completion:*' list-suffixes  # Partial completion suggestions
zstyle ':completion:*' expand prefix suffix


# Prompt ######################################################################

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats 'on %F{blue}%b%f'
setopt PROMPT_SUBST
export PROMPT='
%F{cyan}%n%f in %F{magenta}%M%f ${vcs_info_msg_0_}
%F{yellow}%~%f
: '


# History #####################################################################

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history # Save history
HISTORY_IGNORE='(cd*|cl*|ls*|pwd)'      # Ignore common commands
SAVEHIST=500000                         # Cap history at 500,000 entries
setopt EXTENDED_HISTORY                 # Add timestamp
setopt SHARE_HISTORY                    # Share history between sessions
setopt INC_APPEND_HISTORY               # Add commands when executed, not at shell exit
setopt HIST_EXPIRE_DUPS_FIRST           # Expire duplicates first
setopt HIST_IGNORE_DUPS                 # Don't store duplicates
setopt HIST_FIND_NO_DUPS                # Ignore duplicates when searching through history
setopt HIST_REDUCE_BLANKS               # Remove blank lines from history
setopt HIST_BEEP                        # Beep when accessing a non-existent history entry

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end


# Lazy-load rbenv
rbenv() {
  unset -f rbenv ruby gem bundle irb
  eval "$(command rbenv init -)"
  rbenv "$@"
}
ruby()   { rbenv; command ruby   "$@"; }
gem()    { rbenv; command gem    "$@"; }
bundle() { rbenv; command bundle "$@"; }
irb()    { rbenv; command irb    "$@"; }

# Lazy-load nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { nvm; command node "$@"; }
npm()  { nvm; command npm  "$@"; }
npx()  { nvm; command npx  "$@"; }

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
