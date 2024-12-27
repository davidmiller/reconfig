

# Python environments
export VIRTUALENVWRAPPER_PYTHON=`which python3`
. /usr/local/bin/virtualenvwrapper.sh

export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

# The install said do this /shrug
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

# Title many windows
function title { echo -ne "\033]0;"$*"\007" }

alias reload='source ~/.zshrc'
alias ..='cd ..'


. ~/.zsh/zsh-git-prompt/zshrc.sh

PROMPT='%m :: %2~ %B»%b $(git_super_status)'
