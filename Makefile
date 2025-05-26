list:
	shfmt --list .

lint:
	shfmt --list . | tail -n +2 | xargs shellcheck

fmt_preview:
	shfmt --diff --simplify .

fmt:
	shfmt --list --simplify --write .