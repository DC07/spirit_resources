#!/sbin/sh

mkdir /tmp/ramdisk
cd /tmp/ramdisk
gunzip -c ../boot.img-ramdisk.gz | cpio -i
find . | cpio -o -H newc | gzip > ../newramdisk.cpio.gz
cd /
