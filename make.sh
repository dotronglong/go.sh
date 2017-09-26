#!/bin/bash
say() { echo >&1 -e ":: $*"; }
info() { echo >&1 -e ":: \033[01;32m$*\033[00m"; }
warn() { echo >&2 -e ":: \033[00;31m$*\033[00m"; }
die() { echo >&2 -e ":: \033[00;31m$*\033[00m"; exit 1; }
null() { echo >/dev/null; }

CUR_DIR=$(dirname $0)
if [[ $CUR_DIR = "." ]]; then CUR_DIR=$PWD; fi
BIN_DIR=$CUR_DIR/bin
GLIDE="$BIN_DIR/glide"

glide() {
	if [[ ! -f "$GLIDE" ]]; then
		$CUR_DIR/install.sh glide
	fi
}

deps() {
	glide && clean
	$GLIDE --version
	$GLIDE install --force
}

up() {
	glide
	$GLIDE --version
	$GLIDE update
}

clean() {
	rm -rf $PWD/vendor
}

$*