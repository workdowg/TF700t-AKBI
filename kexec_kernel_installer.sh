#!/system/bin/sh
#Android Kexecboot kernel Installer v2.5
# 06/20/2014
#by workdowg@xda
#This script must be run in the directory it was extracted to

# fail on errors
set -e

#Test for root access
perm=$(id|cut -b 5)
if [ "$perm" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#Test for correct directory
if [ ! -d "that10/" ] ; then
	echo ""
	echo ""
	echo ""
    echo "You are not running this script"
    echo "from the correct directory. Exiting"
    exit
fi
#test for current kernel
#kernel_current=$(cat /proc/version |cut -d " " -f 3 )
#if [ "$kernel_current" != "3.1.10-that10+" ] || [ "$kernel_current" != "3.1.10-10.6.1.14.-that8-oc+" ] ; then
#	echo "You need to be running that10 or"
#	echo "or CROMBi-KK to use this installer"
#	exit 1
#fi

#Android kexec kernel installer 
echo ""
echo ""
echo ""
echo ""
echo "========================================================"
echo "Android Kexec kernel installer V1.5 by workdowg@xda"
echo "========================================================"
echo ""
echo ""
echo "Please make a selection"
echo ""
echo "Choose 1 or 2 only (for now :)"
echo ""
echo "1 - CROMi-X that10 kernel"
echo "2 - CROMBi-X that cm112 kernel"
read kernel_ver
echo "Mounting /system r/w..."
mount -o remount,rw -t ext4 /dev/block/mmcblk0p1 /system || echo "/system not mounted r/w"
mkdir -p /system/boot
case $kernel_ver in
    1) cp that10/* /system/boot/ ;;
    2) cp that_cm112/* /system/boot/ ;;
esac
echo "Remount /system r/o..." 
mount -o remount,ro -t ext4 /dev/block/mmcblk0p1 /system || echo "/system not mounted r/o"
echo ""
echo ""
echo "Android Kexec kernel installer V1.5 - Done!"
echo ""
echo "Press enter to continue or ctr+c to exit"
read
sh ./AKBI_v2.5.sh

