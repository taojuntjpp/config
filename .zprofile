#
# ~/.zprofile
#

[[ -f ~/.zshrc ]] && . ~/.zshrc

#go
export GOPATH=$HOME/apps/go
export PATH=$PATH:$GOPATH/bin
