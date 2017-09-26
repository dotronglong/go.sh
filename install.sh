#!/bin/bash
CUR_DIR=$(dirname $0)
if [[ $CUR_DIR = "." ]]; then CUR_DIR=$PWD; fi
. $CUR_DIR/common.sh

BIN_DIR=$CUR_DIR/bin

glide() {
	VERSION=${1:-"v0.12.3"}
	AROS="$($CUR_DIR/os.sh os)-$($CUR_DIR/os.sh arch)"
	FILE="glide-$VERSION-$AROS.tar.gz"
	LINK="https://github.com/Masterminds/glide/releases/download/$VERSION/$FILE"
	info "Downloading $FILE ..."
	cd $BIN_DIR
	curl -SLO $LINK && tar -xzf $FILE && rm -rf $FILE
	mv $AROS/glide glide && rm -rf $AROS
	info "Glide is installed at $BIN_DIR/glide"
}

$*