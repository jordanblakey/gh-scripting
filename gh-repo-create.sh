#!/usr/bin/env sh

# gh repo create --help
gh repo create \
	gh-scripting \
	--description="Experiments in working with Github through the CLI." \
	--disable-wiki \
	--disable-issues \
	--public \
	--push \
	--remote=origin \
	--source=.
