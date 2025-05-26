# `gh` Scripting

Experiments in working with Github through the CLI.

## Installation

```sh
# note: Actions use dash, a light, POSIX compliant bourne shell alternative.
# note: Use for portability: #!/usr/bin/env sh

# install gh command
./install.sh

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

### Authentication

https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps

```sh
# get detailed info about auth state: accounts, protocol, token scopes
gh auth status
gh auth refresh --scopes write:org,read:public_key # add
gh auth refresh --remove-scopes delete_repo # remove
gh auth refresh --reset-scopes # minimum
```
