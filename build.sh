#!/bin/bash

set -e

TAG=latest

build() {
    NAME=$1
    IMAGE=theforeverlost/spark-$NAME:$TAG
    cd $([ -z "$2" ] && echo "./$NAME" || echo "$2")
    echo '--------------------------' building $IMAGE in $(pwd)
    docker build -t $IMAGE .
    cd -
}

build base
build master
build worker
