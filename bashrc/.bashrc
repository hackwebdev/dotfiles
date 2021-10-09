export PATH=$PATH:~/.local/bin/lvim

alias compass="mongodb-compass"
alias mongodb="mongod --auth --port 27017 -dbpath /home/eckzen/database"

alias reboot="sudo systemctl reboot"
alias poweroff="sudo systemctl poweroff"
alias halt="sudo systemctl halt"
alias n="nvim"
alias unstage="git reset --soft HEAD~1"
alias pre="prettier --write --plugin-search-dir=. ./**/*.svelte"
neofetch

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

gcop(){
  git log \
      --reverse \
      --color=always \
      --format="%C(cyan)%h %C(blue)%ar%C(auto)%d \
               %(yellow)%s%+b %C(black)%ae" "$@" |
      fzf -i -e +s \
          --reverse \
          --tiebreak=index \
          --no-multi \
          --ansi \
          --preview ="echo {} |
                      grep -o '[a-f0-9]\{7\}' |
                      head -1 |
                      xargs -I % sh -c 'git show --color=always % |
                      diff-so-fancy'" \
          --header "enter:view, C-c: copy hash" \
          --bind "enter:execute:$_viewGitLogLine | less-R" \
          --bind "ctrl-c:execute:$_gitLogLineToHash |
                  xclip -r -selection clipboard"
}
