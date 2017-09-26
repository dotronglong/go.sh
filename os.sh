#!/bin/bash

arch() {
	ARCH=$(uname -m)
	case $ARCH in
		armv5*) ARCH="armv5";;
		armv6*) ARCH="armv6";;
		armv7*) ARCH="armv7";;
		aarch64) ARCH="arm64";;
		x86) ARCH="386";;
		x86_64) ARCH="amd64";;
		i686) ARCH="386";;
		i386) ARCH="386";;
	esac
	echo $ARCH
}

os() {
	OS=$(echo `uname`|tr '[:upper:]' '[:lower:]')

	case "$OS" in
		# Minimalist GNU for Windows
		mingw*) OS='windows';;
		msys*) OS='windows';;
	esac
	echo $OS
}

$*