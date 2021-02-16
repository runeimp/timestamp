
alias _build-mac := _build-macos
alias _build-win := _build-windows
alias ver := version


@_default:
	just _term-wipe
	just --list



# Build compiled app
build target='':
	#!/usr/bin/env bash
	set -euo pipefail
	just _term-wipe
	if [[ '{{target}}' = '' ]]; then
		target='{{os()}}'
	else
		target='{{target}}'
	fi
	
	if [[ "${target}" = 'macos' ]] || [[ "${target}" = 'mac' ]]; then
		just _build-macos
		just distro macos bin/macos/timestamp
		# just distro macos-amd64 bin/macos_amd64/timestamp
		# just distro macos-arm64 bin/macos_arm64/timestamp
	elif [[ "${target}" = 'windows' ]] || [[ "${target}" = 'win' ]]; then
		just _build-windows
		just distro windows bin/windows/TimeStamp.exe
	else
		just "_build-${target}"
		just distro "${target}" "bin/${target}/timestamp"
	fi

@_build-linux:
	echo "Building Linux app"
	GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o bin/linux/timestamp main.go

@_build-macos:
	echo "Building macOS app"
	GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -o bin/macos_amd64/timestamp main.go
	# GOOS=darwin GOARCH=arm64 go build -o bin/macos_arm64/timestamp main.go # Not until Go 1.16

@_build-windows:
	echo "Building Windows app"
	GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o bin/windows/TimeStamp.exe main.go


# Setup distrobution archive
distro arch file:
	#!/bin/sh
	path="$(dirname "{{file}}")"
	name="$(basename "{{file}}")"
	ver="$(just version)"
	# echo "path = ${path}"
	# echo "name = ${name}"
	# echo " ver = ${ver}"
	cp LICENSE README.md "${path}/"
	mkdir -p "distro/TimeStamp-v${ver}"
	echo "cd ${path}"
	cd "${path}"
	echo "zip ../../distro/TimeStamp-v${ver}/timestamp-v${ver}-{{arch}}.zip '${name}' LICENSE README.md"
	zip "../../distro/TimeStamp-v${ver}/timestamp-v${ver}-{{arch}}.zip" "${name}" LICENSE README.md
	lsd -hl "../../distro/TimeStamp-v${ver}"


# Run app
run arg='':
	just _term-wipe
	go run main.go {{arg}}



# Wipes the terminal buffer for a clean start
_term-wipe:
	#!/usr/bin/env bash
	set -exo pipefail
	if [[ ${#VISUAL_STUDIO_CODE} -gt 0 ]]; then
		clear
	elif [[ ${KITTY_WINDOW_ID} -gt 0 ]] || [[ ${#TMUX} -gt 0 ]] || [[ "${TERM_PROGRAM}" = 'vscode' ]]; then
		printf '\033c'
	elif [[ "$(uname)" == 'Darwin' ]] || [[ "${TERM_PROGRAM}" = 'Apple_Terminal' ]] || [[ "${TERM_PROGRAM}" = 'iTerm.app' ]]; then
		osascript -e 'tell application "System Events" to keystroke "k" using command down'
	elif [[ -x "$(which tput)" ]]; then
		tput reset
	elif [[ -x "$(which reset)" ]]; then
		reset
	else
		clear
	fi


# Output the app version
@version:
	grep '^\tappLabel' main.go | cut -d'"' -f2 | cut -d'v' -f2

