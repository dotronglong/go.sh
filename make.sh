#!/usr/bin/env bash
CUR_DIR=$(dirname $0)
if [[ $CUR_DIR = "." ]]; then CUR_DIR=$PWD; fi
. $CUR_DIR/common.sh

BIN_DIR=$CUR_DIR/bin
GLIDE="$BIN_DIR/glide"
GLIDE_DIR=$BIN_DIR/.glide

export GLIDE_HOME=$GLIDE_DIR

get-glide() {
	if [[ ! -f "$GLIDE" ]]; then
		$CUR_DIR/install.sh glide
		mkdir -p $GLIDE_DIR
	fi
}

deps() {
	get-glide && clean
	$GLIDE --version
	$GLIDE install --force
}

up() {
	get-glide
	$GLIDE --version
	$GLIDE update
}

cc() {
	get-glide
	$GLIDE --version
	$GLIDE cache-clear
}

clean() {
	rm -rf $PWD/vendor
}

$*