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
	$CUR_DIR/print.sh info "Downloading $FILE ..."
	cd $BIN_DIR
	curl -SLO $LINK && tar -xzf $FILE && rm -rf $FILE
	mv $AROS/glide glide && rm -rf $AROS
	$CUR_DIR/print.sh info "Glide is installed at $BIN_DIR/glide"
}

docker_pkg() {
	apt-get update \
	&& apt-get install -y \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    gnupg2 \
	    software-properties-common
	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -
	add-apt-repository \
	 "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
	 $(lsb_release -cs) \
	 stable"

    apt-get update \
	&& apt-get install -y docker-ce
}

docker() {
	DOCKER_VERSION=17.09.0
	curl -SLO https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION-ce.tgz
	tar -xzf docker-$DOCKER_VERSION-ce.tgz && rm -rf docker-$DOCKER_VERSION-ce.tgz
	cp docker/* /usr/bin/ && rm -rf docker
	groupadd docker
	usermod -aG docker $USER
	dockerd &
}

$*