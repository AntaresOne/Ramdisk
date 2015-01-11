#!/sbin/busybox sh
# Script to check filesystem type and modify mount points with proper options.
#

BB=/sbin/busybox

$BB mount -o remount,rw /;

$BB mv /fstab.qcom /fstab.org;

FS_CACHE0=$(eval $(/sbin/blkid /dev/block/mmcblk0p18 | $BB cut -c 24-); $BB echo $TYPE);
FS_SYSTEM0=$(eval $(/sbin/blkid /dev/block/mmcblk0p16 | $BB cut -c 24-); $BB echo $TYPE);
GPE=`cat /proc/cmdline | grep -o 'samsung.hardware=[^\ ]*'`

if [ "$GPE" == "samsung.hardware=GT-I9505G" ]; then
	FS_DATA0=$(eval $(/sbin/blkid /dev/block/mmcblk0p28 | $BB cut -c 24-); $BB echo $TYPE);
else
	FS_DATA0=$(eval $(/sbin/blkid /dev/block/mmcblk0p29 | $BB cut -c 24-); $BB echo $TYPE);
fi;

if [ "$FS_SYSTEM0" == "ext4" ]; then
	$BB sed -i "s/# EXT4SYS//g" /fstab.tmp;
elif [ "$FS_SYSTEM0" == "f2fs" ]; then
	$BB sed -i "s/# F2FSSYS//g" /fstab.tmp;
fi;

if [ "$FS_CACHE0" == "ext4" ]; then
	$BB sed -i "s/# EXT4CAC//g" /fstab.tmp;
elif [ "$FS_CACHE0" == "f2fs" ]; then
	$BB sed -i "s/# F2FSCAC//g" /fstab.tmp;
else
	$BB sed -i "s/# F2FSCAC//g" /fstab.tmp;
fi;

if [ "$FS_DATA0" == "ext4" ]; then
	$BB sed -i "s/# EXT4DAT//g" /fstab.tmp;
elif [ "$FS_DATA0" == "f2fs" ]; then
	$BB sed -i "s/# F2FSDAT//g" /fstab.tmp;
fi;

$BB mv /fstab.tmp /fstab.qcom;
