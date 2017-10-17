#!/usr/bin/env bash
CUR_DIR=$(dirname $0)
if [[ $CUR_DIR = "." ]]; then CUR_DIR=$PWD; fi
. $CUR_DIR/common.sh

BIN_DIR=$CUR_DIR/bin
GO=go

export_ldflags() {
    build_date="$(date -u "+%Y-%m-%d %H:%M:%S") +00:00"
    app_version_suffix=$(test -n "$(git status --porcelain)" && echo ".dirty")
    short_hash=$(git rev-parse --short HEAD)
    app_version=$(git branch | grep '*' | cut -f2 -d' ')
    if [ $app_version == "master" ]; then
        app_version="${app_version}@${short_hash}"
    fi

    if [ "$app_version_suffix" != "" ]; then
        app_version="${app_version}${app_version_suffix}"
    fi
    go_version=$(${GO} version | sed -E 's|.*go(([0-9]+\.){1,2}[0-9]+) .*|\1|g')
    git_log=$(git log --decorate --oneline -n1 | sed -e "s/'/ /g" -e "s/\"/ /g" -e "s/\#/\№/g" -e 's/`/ /g')
#    git_describe=$(git describe --tags --long)
#    seed_version="$(grep -A1 'package: gitlab.com/godpin/seed' glide.yaml | tail -1 | cut -d':' -f2 | xargs)@$(grep -A1 'name: gitlab.com/godpin/seed' glide.lock | tail -1 | cut -d':' -f2 | xargs)"
    seed_version="$(grep -A1 'name: gitlab.com/godpin/seed' glide.lock | tail -1 | cut -d':' -f2 | xargs)"
    export LDFLAGS="-X 'main.AppVersion=${app_version}' -X 'main.GoVersion=${go_version}' -X 'main.BuildDate=${build_date}' -X 'main.GitLog=${git_log}' -X 'main.SeedVersion=${seed_version}'"
}

ci() {
	export_ldflags
	${GO} build -ldflags $LDFLAGS -o $BIN/api $APP_DIR/main.go
}

$*