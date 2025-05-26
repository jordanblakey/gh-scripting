#!/usr/bin/env sh

# main
gh repo edit --description="Experiments in working with Github through the CLI."
gh repo edit --visibility public --accept-visibility-change-consequences
gh repo edit --homepage="github.com/jordanblakey/gh-scripting"
gh repo edit --add-topic="automation,github,dubious"
gh repo edit --remove-topic="dubious"
gh repo edit --default-branch=main

# features
gh repo edit --enable-advanced-security=false
gh repo edit --enable-auto-merge=false
gh repo edit --enable-discussions=false
gh repo edit --enable-issues=false
gh repo edit --enable-merge-commit=false
gh repo edit --enable-projects=false
gh repo edit --enable-projects=false
gh repo edit --enable-rebase-merge=false
gh repo edit --enable-secret-scanning=false
gh repo edit --enable-secret-scanning-push-protection=false
gh repo edit --enable-squash-merge=false
gh repo edit --enable-wiki=false

# branching and forking behaviour
gh repo edit --allow-forking=false
gh repo edit --allow-update-branch=true
gh repo edit --delete-branch-on-merge=true
gh repo edit --template=false
