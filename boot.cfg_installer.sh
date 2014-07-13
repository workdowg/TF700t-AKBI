#!/system/bin/sh
#Android Kexecboot boot.cfg Installer - TF700t-AKBI v2.5.4
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
if [ ! -f boot.cfg ] ; then
    echo "You are not running this script"
    echo "from the correct directory. Exiting"
    exit
fi


#boot.cfg installer 
echo ""
echo ""
echo ""
echo ""
echo "========================================================"
echo "Kexecboot boot.cfg installer V1.5 by workdowg@xda"
echo "========================================================"
echo ""
echo ""
echo "We will also backup your exsisting boot.cfg"
echo "here as boot.cfg.old"
echo ""
echo ""
echo "Press enter to continue or ctr+c to exit"
read
mkdir -p /data/media/0/kexecbootcfg
mount -t vfat /dev/block/mmcblk0p5 /data/media/0/kexecbootcfg/
echo "Backing up boot.cfg..."
if [ -e /data/media/0/kexecbootcfg/multiboot/boot.cfg ]
 then cp /data/media/0/kexecbootcfg/multiboot/boot.cfg boot.cfg.old
fi
mkdir -p /data/media/0/kexecbootcfg/multiboot/
cp boot.cfg /data/media/0/kexecbootcfg/multiboot/
echo ""
echo ""
echo "Copying new boot.cfg..."
echo ""
echo ""
echo "Waiting for sync..."
sleep 10
umount /data/media/0/kexecbootcfg/
rm -r /data/media/0/kexecbootcfg
echo ""
echo ""
echo "Kexecboot boot.cfg installer V1.5 - Done!"
echo ""
echo "Press enter to continue or ctr+c to exit"
read
sh ./TF700t-AKBI.sh
