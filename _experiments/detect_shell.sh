#!/usr/bin/env sh

# Attempt to determine the running shell.
# First, try 'ps'. If 'ps' is not available (e.g., in some minimal containers),
# try reading from /proc/$$/comm on Linux systems.
# --- Shell Detection Logic ---
# This logic attempts to identify the shell running the script.
# It's not foolproof, as shells can be invoked in compatibility modes
# or specific variables might not be set
_current_shell="Unknown"
_initial_exe_name=""    # Name from ps or /proc/$$/comm
_actual_exe_basename="" # Name from resolved /proc/$$/exe
_shell_detection_details=""

# Function to append details for the report
_add_detail() {
	if [ -z "$_shell_detection_details" ]; then
		_shell_detection_details="$1"
	else
		_shell_detection_details="$_shell_detection_details; $1"
	fi
}

# 1. Try to get command name via ps
if command -v ps >/dev/null 2>&1; then
	_initial_exe_name=$(ps -p $$ -o comm=)
	if [ -n "$_initial_exe_name" ]; then
		_add_detail "ps comm: $_initial_exe_name"
	fi
fi

# 2. Try /proc/$$/comm if ps failed or gave no result (Linux-specific)
if [ -z "$_initial_exe_name" ] && [ -r "/proc/$$/comm" ]; then
	_initial_exe_name=$(cat "/proc/$$/comm")
	if [ -n "$_initial_exe_name" ]; then
		_add_detail "/proc/$$/comm: $_initial_exe_name"
	fi
fi

# 3. Refine with /proc/$$/exe (Linux-specific) to get the actual executable basename
# This helps if 'sh' is a symlink to 'bash', 'dash', etc.
if [ -L "/proc/$$/exe" ] && command -v readlink >/dev/null 2>&1 && command -v basename >/dev/null 2>&1; then
	_resolved_exe_path=$(readlink -f "/proc/$$/exe" 2>/dev/null || readlink "/proc/$$/exe" 2>/dev/null)
	if [ -n "$_resolved_exe_path" ]; then
		_actual_exe_basename=$(basename "$_resolved_exe_path")
		if [ "$_actual_exe_basename" != "$_initial_exe_name" ] && [ -n "$_initial_exe_name" ]; then
			_add_detail "/proc/$$/exe -> $_actual_exe_basename"
		elif [ -z "$_initial_exe_name" ] && [ -n "$_actual_exe_basename" ]; then # If initial was empty, this is our first concrete name
			_add_detail "/proc/$$/exe -> $_actual_exe_basename"
		fi
	fi
fi

# Determine the most reliable candidate name for shell type checking
_final_candidate_name=""
if [ -n "$_actual_exe_basename" ]; then # Resolved exe path is most reliable
	_final_candidate_name="$_actual_exe_basename"
elif [ -n "$_initial_exe_name" ]; then # Fallback to ps/comm name
	_final_candidate_name="$_initial_exe_name"
fi

# 4. Identify based on version variables (highest priority) or the candidate name
if [ -n "$BASH_VERSION" ]; then
	_current_shell="bash"
	_add_detail "BASH_VERSION: $BASH_VERSION"
elif [ -n "$ZSH_VERSION" ]; then
	_current_shell="zsh"
	_add_detail "ZSH_VERSION: $ZSH_VERSION"
elif [ -n "$FISH_VERSION" ]; then # fish shell
	_current_shell="fish"
	_add_detail "FISH_VERSION: $FISH_VERSION"
elif [ -n "$KSH_VERSION" ]; then # Some ksh versions set this
	_current_shell="ksh"
	_add_detail "KSH_VERSION: $KSH_VERSION"
else # No specific version variable found, rely on the executable name
	if [ "$_final_candidate_name" = "bash" ]; then
		_current_shell="bash"
		_add_detail "Identified as bash by name"
	elif [ "$_final_candidate_name" = "zsh" ]; then
		_current_shell="zsh"
		_add_detail "Identified as zsh by name"
	elif [ "$_final_candidate_name" = "ksh" ] || [ "$_final_candidate_name" = "mksh" ] || [ "$_final_candidate_name" = "pdksh" ]; then
		_current_shell="ksh"
		_add_detail "Identified as ksh by name ($_final_candidate_name)"
	elif [ "$_final_candidate_name" = "dash" ]; then
		_current_shell="dash"
		_add_detail "Identified as dash by name"
	elif [ "$_final_candidate_name" = "fish" ]; then
		_current_shell="fish"
		_add_detail "Identified as fish by name"
	elif [ "$_final_candidate_name" = "sh" ]; then
		_current_shell="sh (generic or compatible)"
		_add_detail "Identified as sh by name"
	elif [ -n "$_final_candidate_name" ]; then # If we have a name but it's not recognized above
		_current_shell="$_final_candidate_name (unclassified)"
	else # No name could be determined at all
		_current_shell="sh (assumed due to shebang, no specific info found)"
		_shell_detection_details="No specific shell info could be determined."
	fi
fi
echo "--- Shell Detection Report ---"
echo "Running Shell: $_current_shell"
if [ -n "$_shell_detection_details" ]; then
	echo "Detection Details: $_shell_detection_details"
fi
echo "----------------------------"
# --- End Shell Detection Logic ---
