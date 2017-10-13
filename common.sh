#!/usr/bin/env bash
say() { echo >&1 -e ":: $*"; }
info() { echo >&1 -e ":: \033[01;32m$*\033[00m"; }
warn() { echo >&2 -e ":: \033[00;31m$*\033[00m"; }
die() { echo >&2 -e ":: \033[00;31m$*\033[00m"; exit 1; }
null() { echo >/dev/null; }