#!/usr/bin/env sh

ensure_dpkg_installed() {
	local package_name="$1"
	if ! dpkg -s "$package_name" >/dev/null 2>&1; then
		echo "Package '$package_name' is NOT installed."
		sudo apt install -y "$package_name"
	else
		echo "Package '$package_name' is installed."
	fi
}
