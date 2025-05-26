list:
	shfmt --list .

lint:
	shfmt --list . | tail -n +2 | xargs shellcheck

fmt_preview:
	shfmt --diff --simplify .

fmt:
	shfmt --list --simplify --write .

install_hook:
	echo "#!/usr/bin/env sh\n\nmake fmt" > pre-commit && chmod +x pre-commit && cp pre-commit .git/hooks && rm pre-commit