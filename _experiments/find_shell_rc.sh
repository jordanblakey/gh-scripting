#!/usr/bin/env sh

# This script attempts to find common RC (run commands) files
# for the currently running shell.

# Source the shell detection script to get the _current_shell variable.
# Assumes detect_shell.sh is in the same directory.

ABSPATH="$(realpath $(dirname $BASH_SOURCE))"

. "$ABSPATH/detect_shell.sh"

# _current_shell should now be set (e.g., "Bash", "Zsh", "Dash", "sh (generic or compatible)")

echo "--- RC File Detection for Shell: $_current_shell ---"
_found_rc_files_report=""

# Helper function to check for file existence and append to report
# $1: file_path_to_check (can include ~/)
# $2: description_of_file
_add_to_report_if_exists() {
  local file_path_to_check="$1"
  local description_of_file="$2"
  local actual_path # Path after resolving $HOME or other variables

  # Expand ~ if present at the beginning of the path
  case "$file_path_to_check" in
    "~/"*) actual_path="$HOME/${file_path_to_check#"~/"}" ;;
    *)    actual_path="$file_path_to_check" ;;
  esac

  if [ -f "$actual_path" ] && [ -r "$actual_path" ]; then
    if [ -z "$_found_rc_files_report" ]; then
      _found_rc_files_report="$description_of_file: $actual_path"
    else
      # Using printf for newline to ensure portability (echo -e is not POSIX)
      _found_rc_files_report=$(printf "%s\n%s: %s" "$_found_rc_files_report" "$description_of_file" "$actual_path")
    fi
  fi
}

case "$_current_shell" in
  "Bash")
    _add_to_report_if_exists "~/.bashrc" "Primary interactive RC"
    _add_to_report_if_exists "~/.bash_profile" "Login RC (often sources .bashrc)"
    _add_to_report_if_exists "~/.bash_login" "Login RC (alternative to .bash_profile)"
    _add_to_report_if_exists "~/.profile" "Login RC (generic, sourced if .bash_profile/.bash_login not found)"
    ;;
  "Zsh")
    _zdot_dir_val="${ZDOTDIR:-$HOME}" # Use $HOME if ZDOTDIR is not set or empty
    _add_to_report_if_exists "${_zdot_dir_val}/.zshenv" "Always sourced (even for non-interactive/non-login)"
    _add_to_report_if_exists "${_zdot_dir_val}/.zshrc" "Primary interactive RC"
    _add_to_report_if_exists "${_zdot_dir_val}/.zprofile" "Login RC (sourced before .zshrc)"
    _add_to_report_if_exists "${_zdot_dir_val}/.zlogin" "Login RC (sourced after .zshrc)"
    ;;
  "Ksh")
    # ENV is significant for ksh interactive sessions
    if [ -n "$ENV" ]; then
      _add_to_report_if_exists "$ENV" "Interactive RC (from ENV variable)"
    fi
    _add_to_report_if_exists "~/.kshrc" "Common interactive RC (if ENV not set or points elsewhere)"
    _add_to_report_if_exists "~/.profile" "Login RC"
    ;;
  "Dash"|"sh (generic or compatible)")
    # For POSIX sh (like dash), ENV is key for non-login interactive shells
    if [ -n "$ENV" ]; then
      _add_to_report_if_exists "$ENV" "Interactive RC (from ENV variable)"
    fi
    # All POSIX-compliant login shells (sh, dash, bash, ksh, zsh in sh/ksh mode) source ~/.profile
    _add_to_report_if_exists "~/.profile" "Login RC (standard for POSIX sh)"
    ;;
  *)
    _found_rc_files_report="Cannot determine common RC files for unknown or unhandled shell: '$_current_shell'"
    ;;
esac

if [ -n "$_found_rc_files_report" ]; then
  echo "Potential RC file(s) found:"
  printf "%s\n" "$_found_rc_files_report"
else
  echo "No common RC files found or applicable for '$_current_shell' based on standard checks."
  echo "Note: Shells might be configured to use non-standard RC files, or might not use one for the current invocation type (e.g., non-interactive script)."
fi
echo "--------------------------------------"
