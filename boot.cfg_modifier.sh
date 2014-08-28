#!/system/bin/sh
#Android Kexecboot boot.cfg modifier Installer - TF700t-AKBI v2.6.4
# 07/30/2014
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
#cd into correct directory
workingdir=$(dirname "$0")
cd $workingdir
#Test for correct directory
if [ ! -f boot.cfg ] ; then
    echo "You are not running this script"
    echo "from the correct directory. Exiting"
    exit
fi
#modify boot.cfg
echo ""
echo ""
echo ""
echo ""
echo "========================================================"
echo "Kexecboot boot.cfg modifier by workdowg@xda"
echo "========================================================"
echo ""
echo ""
#make temp directories
mkdir -p /data/media/0/kexectemp1
mkdir -p /data/media/0/kexectemp2
#mount mmcblk0p5
mount -t vfat /dev/block/mmcblk0p5 /data/media/0/kexectemp1/
cp /data/media/0/kexectemp1/multiboot/boot.cfg /data/media/0/kexectemp2/boot.tmp
#make boot.tmp writable by regular user
chown media_rw:media_rw /data/media/0/kexectemp2
chown media_rw:media_rw /data/media/0/kexectemp2/boot.tmp
echo "Now switch to a text editor"
echo "and carefully edit"
echo "/data/media/0/kexectemp2/boot.tmp"
echo "Then return here and press enter to continue"
echo ""
read
cp /data/media/0/kexectemp2/boot.tmp /data/media/0/kexectemp1/multiboot/boot.cfg
echo ""
echo ""
echo "Waiting for sync..."
sleep 10
umount /data/media/0/kexectemp1/ || echo "Warning: could not unmount /dev/block/mmcblk0p5"
rm -r /data/media/0/kexectemp1
rm -r /data/media/0/kexectemp2
echo "DONE! Please reboot and profit."
echo "========================================================"
echo "Press enter to continue or ctr+c to exit"
read
sh ./TF700t-AKBI.sh
