#!/system/bin/sh
#Android Kexecboot boot.cfg/restorer Installer - TF700t-AKBI v2.6.1
# 07/31/2014
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
#boot.cfg installer 
echo ""
echo ""
echo ""
echo ""
echo "========================================================"
echo "Kexecboot boot.cfg installer/restorer by workdowg@xda"
echo "========================================================"
echo ""
echo ""
echo "With this script you can:"
echo ""
echo "1) Install default boot.cfg (and backup exsisting)"
echo "2) Restore boot.cfg.old (NO backup of exsisting)"
echo "3) Exit"
echo ""
read z
echo ""
case $z in
    1) mkdir -p /data/media/0/kexecbootcfg
		mount -t vfat /dev/block/mmcblk0p5 /data/media/0/kexecbootcfg/
		echo "Backing up boot.cfg..."
		if [ -f /data/media/0/kexecbootcfg/multiboot/boot.cfg ]
		then cp -f /data/media/0/kexecbootcfg/multiboot/boot.cfg boot.cfg.old
		fi
		mkdir -p /data/media/0/kexecbootcfg/multiboot/
		cp boot.cfg /data/media/0/kexecbootcfg/multiboot/
		echo ""
		echo ""
		echo "Copying default boot.cfg..."
		echo ""
		echo ""
		echo "Waiting for sync..."
		sleep 10
		umount /data/media/0/kexecbootcfg/
		rm -r /data/media/0/kexecbootcfg
		echo ""
		echo ""
		echo "Kexecboot boot.cfg installer - Done!"
		echo ""
		echo "Press enter to continue or ctr+c to exit"
		read
		sh ./TF700t-AKBI.sh ;;
	2)  ls *.old || echo "No boot.cfg.old found"
		echo ""
		ls
		echo ""
		echo "Enter a file to restore..."
		echo ""
		read oldfile
		if [ ! -f "$oldfile" ] ; then
		echo ""
		echo "File doesn't exist or entred wrong, run installer again."
		exit 1
		fi
		echo ""
		mkdir -p /data/media/0/kexecbootcfg
		mount -t vfat /dev/block/mmcblk0p5 /data/media/0/kexecbootcfg/
		cp -f "$oldfile" /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo ""
		echo ""
		echo "Restoring $oldfile ..."
		echo ""
		echo ""
		echo "Waiting for sync..."
		sleep 10
		umount /data/media/0/kexecbootcfg/
		rm -r /data/media/0/kexecbootcfg
		echo ""
		echo ""
		echo "Kexecboot boot.cfg installer - Done!"
		echo ""
		echo "Press enter to continue or ctr+c to exit"
		read
		sh ./TF700t-AKBI.sh ;;
    3) echo "Exiting..."
		echo ""
		exit 1 ;;
    *) echo "Invalid selection, run installer again"
		echo ""
		exit
esac
read

