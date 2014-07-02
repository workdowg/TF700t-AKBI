#!/system/bin/sh
#Android Kexecboot Installer v2.5
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
echo ""
echo ""
echo ""
echo "************************************"
echo "*   Android Kexecboot Installer "
echo "*    for the TF700t v2.5 "
echo "************************************"
echo ""
echo ""
echo ""

echo "Please choose your need..."
echo "1 - Kexec Blob Install/Update"
echo "2 - Android Kexec Kernel Install/Update"
echo "3 - Boot.cfg Install"
echo "4 - Boot.cfg Manual Editor"
echo "5 - Rootfs Installer "
echo "Any other key to exit"
read n

case $n in
    1) sh ./blob_installer.sh ;;
    2) sh ./kexec_kernel_installer.sh ;;
    3) sh ./boot.cfg_installer.sh ;;
    4) sh ./boot.cfg_modifier.sh ;;
    5) sh ./rootfs_installer.sh ;;
    *) exit
esac
