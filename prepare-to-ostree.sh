#!/bin/sh


PREFIX=/tmp/flat
TARGET=$PREFIX/buildroot-prepare/files
ROOT=$PREFIX/buildroot
sudo rm -fr $TARGET
mkdir -p $TARGET
sudo cp metadata.runtime $PREFIX/buildroot-prepare/
mv $ROOT/usr/* $TARGET/
cp -r --preserve=links $ROOT/lib64/* $TARGET/lib64/
cp $ROOT/bin/bash $TARGET/bin/
rm $TARGET/bin/sh
cd $TARGET/bin 
ln -s bin/bash sh
mv $ROOT/etc/ $TARGET/
mv $ROOT/app $TARGET/

mkdir -p $TARGET/share/
ln -s $ROOT/var/lib/rpm $TARGET/share/rpm
