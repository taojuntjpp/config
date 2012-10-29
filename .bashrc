# .bashrc

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH


parse_git_branch() {
	git branch --no-color 2> /dev/null|sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1]/"
}
PS1_GIT="\[\033[38;5;39m\]"'$(parse_git_branch)'"\[\033[00m\]"
PS1_TMP="[\u@\h \W]\\$ "
export PS1="$PS1_TMP$PS1_GIT\n» "
