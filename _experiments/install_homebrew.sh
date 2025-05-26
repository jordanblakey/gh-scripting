#!/usr/bin/bash

ABSPATH="$(realpath $(dirname $BASH_SOURCE))"

. "$ABSPATH/ensure_dpkg_installed.sh"
. "$ABSPATH/find_shell_rc.sh"

# install homebrew
if [ "$1" = "uninstall" ]; then
	echo 'uninstalling brew'
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	exit
elif ! command -v brew >/dev/null 2>&1; then
	echo 'installing brew'
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null # Prevent stdin capture
	# ensure apt deps installed
	ensure_dpkg_installed "build-essential"
	ensure_dpkg_installed "gcc"
	# check shellenv sourced from bashrc
	if [ -z "$(cat ~/.bashrc | grep shellenv)" ]; then
		echo "didn't find line"
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.bashrc
	else
		echo "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv) already in ~/.bashrc"
	fi
	echo 'brew install complete:' $(brew --version)
else
	echo 'brew is installed:' $(brew --version)
fi

if command -v brew >/dev/null 2>&1; then
	if ! command -v shellcheck >/dev/null 2>&1; then
		echo 'installing shellcheck...'
		brew install shellcheck
	else
		echo 'shellcheck is installed:'
	fi
	shellcheck --version
fi
