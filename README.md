# `gh` Scripting

Experiments in working with Github through the CLI.

```sh
# the shortlist
gh repo # list | create | clone | view
gh issue # list | create | comment | close | delete | view
```

## Installation

```sh
# note: Actions use dash, a light, POSIX compliant bourne shell alternative.
# note: Use for portability: #!/usr/bin/env sh

# install gh command
./install.sh
```

## Overview

```sh
# CORE
gh --help
# auth | browse | codespace | gist | issue | org | pr | co | project | release | repo

# ACTIONS COMMANDS
# cache | run | workflow

# ADDITIONAL COMMANDS
# alias | api | attestation | completion | config | extension | gpg-key | label
# ruleset | search | secret | ssh-key | status | variable

# HELP TOPICS
# accessibility | actions | environment | exit-codes | formatting | mintty | reference
```

## Authentication

https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps

```sh
# get detailed info about auth state: accounts, protocol, token scopes
gh auth status
gh auth refresh --scopes write:org,read:public_key # add
gh auth refresh --remove-scopes delete_repo # remove
gh auth refresh --reset-scopes # minimum
```

## API

API exists and is accessible through the CLI with `gh api`.

http://cli.github.com/manual/gh_api
https://docs.github.com/en/rest
https://docs.github.com/en/rest/quickstart

```sh
# Endpoints: Actions | Activity | Apps | Billing | Branches |
# Security campaigns | Checks | Classroom | Code Scanning |
# Security Settings | Codes of conduct | Codespaces | Collaborators |
# Commits | Copilot | Credentials | Dependabot | Dependency graaph |
# Deploy keys | Deployments | Emojis | Gists | Git dataset | Gitignore |
# Interactions | Issues | Licenses | Markdown | Meta | Metrics | Migrations |
# Models | Organizations | Packages | Pages | Private registries |
# Projects (classic) | Pull requests | Rate Limit | Reactions | Releases |
# Search | Secret scanning | Security advisories | Teams | Users

gh api repos/jordanblakey/gh-scripting
gh api repos/jordanblakey/gh-scripting | jq .security_and_analysis.secret_scanning.status
gh api /octocat --method GET
gh api /octocat -X GET

# no CLI needed... except to get a bearer token
curl -X GET https://api.github.com/repos/octocat/Spoon-Knife/issues \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer $(gh auth token)"

curl -X POST $URL -H "Accept: application/vnd.github/json" \
-H "X-GitHub-Api-Version: 2022-11-28" \
-H "Authorization: Bearer $(gh auth token)" \
--data '{"title":"hello from REST","body":"echo echo echo"}'
```
