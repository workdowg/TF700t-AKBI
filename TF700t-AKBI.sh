#!/system/bin/sh
#Android Kexecboot Installer - TF700t-AKBI v2.5.7
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

#Test for correct directory
if [ ! -f boot.cfg ] ; then
   echo "You are not running this script"
   echo "from the correct directory. Exiting"
   exit
fi
echo ""
echo ""
echo ""
echo "************************************"
echo "*   Android Kexecboot Installer "
echo "*       TF700t-AKBI v2.5.7 "
echo "************************************"
echo ""
echo ""
echo ""

echo "Please choose your need..."
echo ""
echo " The rootfs installer now allows you to"
echo " add an entry for your new rootfs image in"
echo " the boot.cfg."
echo ""

echo "1 - Kexec Blob Install/Update"
echo "2 - Android Kexec Kernel Install/Update"
echo "3 - Rootfs/boot.cfg Installer "
echo "4 - Default Boot.cfg Install"
echo "5 - Boot.cfg Manual Editor"
echo "Any other key to exit"
read n

case $n in
    1) sh ./blob_installer.sh ;;
    2) sh ./kexec_kernel_installer.sh ;;
    3) sh ./rootfs_installer.sh ;;
    4) sh ./boot.cfg_installer.sh ;;
    5) sh ./boot.cfg_modifier.sh ;;
    *) exit
esac
