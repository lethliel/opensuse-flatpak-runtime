#!/bin/sh

SRC_COMMIT=$1
shift
DST_COMMIT=$1
shift
METADATA=$1
shift

set -e
DIR=`mktemp -d /tmp/.commit-XXXXXX`

set -x
cp $METADATA $DIR/metadata
while (( "$#" )); do
    sudo mkdir -p `dirname $DIR/$2`
    sudo ostree checkout --repo=/tmp/flat/repo --subpath=$1 -U $SRC_COMMIT $DIR/$2
    shift 2
done
sudo ostree commit --repo=/tmp/flat/repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" --branch $DST_COMMIT $DIR
sudo rm -rf $DIR
