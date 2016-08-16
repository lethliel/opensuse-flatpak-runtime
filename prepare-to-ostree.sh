#!/bin/sh


PREFIX=/tmp/flat
TARGET=$PREFIX/buildroot-prepare/files
ROOT=$PREFIX/buildroot
sudo rm -fr $TARGET
mkdir -p $TARGET
sudo cp metadata.runtime /tmp/flat/buildroot-prepare/
mv $ROOT/usr/* $TARGET/
cp $ROOT/bin/bash $TARGET/bin/
rm $TARGET/bin/sh
cd $TARGET/bin 
ln -s bin/bash sh
mv $ROOT/etc/ $TARGET/
mv $ROOT/app $TARGET/

mkdir -p $TARGET/share/
ln -s $ROOT/var/lib/rpm $TARGET/share/rpm
