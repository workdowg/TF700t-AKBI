#!/system/bin/sh
#Android Kexecboot Installer - TF700t-AKBI v2.6.0
# 08/08/2014
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
echo ""
echo ""
echo ""
echo "************************************"
echo "*   Android Kexecboot Installer "
echo "*       TF700t-AKBI v2.6.0 "
echo "************************************"
echo ""
echo ""
echo ""
echo ""
echo "1 - First time install ONLY - kexec blob, Android kexec kernel and boot.cfg"
echo "2 - Kexec Blob Install/Update"
echo "3 - Android Kexec Kernel Install/Update"
echo "4 - Rootfs/boot.cfg Installer "
echo "5 - Boot.cfg Install/Restore"
echo "6 - Boot.cfg Manual Editor"
echo "Any other key to exit"
echo ""
echo ""
echo "Remember menu items 1 and 4 require ONE rootfs.tar.lzma file to"
echo "be in the install directory."
echo ""
read n
case $n in
    1) if [ -d /data/media/linux/ ] ; then
    echo "Previous install detected, please use"
    echo "other menu options"
    sh ./TF700t-AKBI.sh
    fi
    sh ./firstinstall.sh ;;
    2) sh ./blob_installer.sh ;;
    3) sh ./kexec_kernel_installer.sh ;;
    4) sh ./rootfs_installer.sh ;;
    5) sh ./boot.cfg_installer.sh ;;
    6) sh ./boot.cfg_modifier.sh ;;
    *) exit
esac
