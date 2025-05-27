# `gh` Scripting

Experiments in working with Github through the CLI.

```sh
# will use often
gh repo # list | create | clone | view
gh issue # list | create | comment | close | delete | view
gh auth # login | status | token | refresh
gh codespace # list | create | code | stop
```

## Installation

```sh
# note: Actions use dash, a light, POSIX compliant bourne shell alternative.
# note: Use for portability: #!/usr/bin/env sh

# install gh command
./install.sh

# shfmt & shellcheck: `make list`, `make lint`, `make fmt`, `make fmt_preview`
cat Makefile
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
gh auth login
gh auth refresh --scopes write:org,read:public_key # add
gh auth refresh --scopes 'codespace'
gh auth refresh --remove-scopes delete_repo # remove

# for debug, but don't
gh auth login --scopes admin:gpg_key,admin:org,admin:org_hook,admin:public_key,admin:repo_hook,codespace,delete_repo,delete:packages,gist,notifications,project,public_repo,read:audit_log,read:gpg_key,read:org,read:packages,read:project,read:public_key,read:repo_hook,read:user,repo_deployment,repo:invite,repo:status,security_events,user,user:email,user:follow,workflow,write:gpg_key,write:org,write:packages,write:public_key,write:repo_hook
gh auth refresh --reset-scopes # minimum
```

## API

API exists and is accessible through the CLI with `gh api`.

- http://cli.github.com/manual/gh_api
- https://docs.github.com/en/rest
- https://docs.github.com/en/rest/quickstart

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

## Codespaces

```sh
# list available codespace sizes (from existing codespace)
gh api /user/codespaces/CODESPACE-NAME/machines

# create a new codespace
 gh codespace create --display-name virtually-magic-box \
 --repo jordanblakey/gh-scripting \
 --location EastUs \
 --machine standardLinux32gb \
 --status

gh codespace view --codespace $CODESPACE_NAME # note that name is not display name

# different ways of listing and filtering codespace names with jq
gh codespace list --json name --jq .[].name # get names of all codespaces
gh cs list --json name,repository --jq "first(.[] | select(.repository | contains(\"part-of-repo-name\")) | .name)" > /tmp/buffer # get name of a codespace by
set CODESPACE_NAME $(cat /tmp/buffer)
set CODESPACE_NAME $(gh cs list --json 'name' --jq '.[] | select(.name | contains("space-memory")) | .name')
gh cs list --json name,repository --jq "first(.[] | select(.repository | contains(\"part-of-repo-name\")) | .name)"

# or make a comma sep name,repo list that is greppable,cuttable. this may be the most practical and portable
alias cslist "gh cs list --json name,repository --jq '.[] | join(\",\")'"
# note: within codespace, permissions appear to be limited to the current repository, so list yields only the current codespace
cslist | grep part-of-name-or-repo

# note: you can connect to multiple codespaces simultaneously
gh codespace code --codespace virtually-magic-box # open codespace in vscode ssh
# shorthand to open codespace
gh cs code -c $CODESPACE_NAME

# cleanup
# note: you can only have 2 codespaces running at a time
# note: codespaces seem to be permanently tied to a single repository
gh cs stop -c $CODESPACE_NAME
gh cs view -c $CODESPACE_NAME # confirm stopping
gh cs delete -c $CODESPACE_NAME

# see also
gh cs logs # doesn't seem to work
gh cs ssh
```
