#!/bin/bash
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info_inline "Creating symbolic link to coffee-script cli"
rm ./coffee &>/dev/null

target='./node_modules/.bin/coffee'

if [ ! -f "$target" ] || [ ! -x "$target" ]; then
	err 1
	info_err_clean "target file '$target' not found";
	exit 1
fi

if ln -s "$target" ./coffee &>/dev/null; then ok; else err; fi
