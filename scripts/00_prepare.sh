#!/bin/bash -e
# FIXME should check prereqs, OS, etc

get_key() {
	cat "$1" | grep -A1 "<key>$2</key>" | tail -1 | cut -d '>' -f 2 | cut -d '<' -f 1
}

mkdir -p work
cd work
unzip -p "$1" Restore.plist 2>/dev/null > Restore.plist
if [ ! -s Restore.plist ] ; then
	echo "Not an IPSW file: $1"
	rm -f Restore.plist
	exit 1
fi
ptype=`get_key Restore.plist ProductType`
pvers=`get_key Restore.plist ProductVersion`
build=`get_key Restore.plist ProductBuildVersion`
bcfg=`get_key Restore.plist BoardConfig`
rramdisk=`cat Restore.plist | grep -A999 '>RestoreRamDisks<' | grep -B999 -m1 '</dict>' | grep -A1 '>User<' | grep -F '.dmg<' | cut -d '>' -f 2 | cut -d '<' -f1`
sysimg=`cat Restore.plist | grep -A999 '>SystemRestoreImages<' | grep -B999 -m1 '</dict>' | grep -A1 '>User<' | grep -F '.dmg<' | cut -d '>' -f 2 | cut -d '<' -f1`
bndl=../FirmwareBundles/Down_${ptype}_${pvers}_${build}.bundle
if [ ! -d "$bndl" ]; then
	echo "Please use the iPhone3,1 iOS 6.1.3 IPSW as input."
	rm -f Restore.plist
	exit 1
fi
if [ "$2" != "reset" ]; then
	iv='b559a2c7dae9b95643c6610b4cf26dbd'
	key='3dbe8be17af793b043eed7af865f0b843936659550ad692db96865c00171959f'
	echo $iv > iv
	echo $key > key
fi
echo $ptype > ptype
echo $pvers > pvers
echo $build > build
echo $bcfg > bcfg
echo $rramdisk > rramdisk
echo $sysimg > sysimg
rm -f Restore.plist
