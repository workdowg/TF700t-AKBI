#!/system/bin/sh
#Android Kexecboot First time install Installer - TF700t-AKBI v2.6.1
# 08/08/2014
#by workdowg@xda
#This script must be run in the directory it was extracted 

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
#test for previous install
if [ ! -d kexec.blob ] ; then
    echo "You have already run this installer or"
    echo "have a current kexec install. Please"
    echo "run the main installer again."
    echo ""
    echo "Exiting"
    echo ""
    exit
fi
#variables
export installer_path=$(pwd -P)
export kit=/data/media/linux
if [ ! -d $kit ]; then
	mkdir /data/media/linux; 
fi
export bin=/system/bin
export mnt=/data/local/mnt
if [ ! -d $mnt ]; then
	mkdir $mnt; 
fi
export PATH=$bin:/usr/bin:/usr/local/bin:/usr/sbin:/bin:/usr/local/sbin:/usr/games:$PATH
echo ""
echo ""
echo ""
 echo ""
echo "************************************"
echo "*   TF700t-AKBI first run Installer "
echo "************************************"
echo ""
echo "This will install everything needed for a successful"
echo "kexecboot installation. Kexec blob, Android kexec kernel and a boot.cfg."
echo "You will still be prompted several times. If this installer fails at any point,"
echo "you will need to run the main installer again starting with menu item 2."
echo ""
echo "Press enter to continue, ctrl+c to exit."
echo ""
read
#kexecboot kernel install
#Test for correct directory
if [ ! -f kexec.blob ] ; then
    echo "You are not running this script"
    echo "from the correct directory. You will now need to"
    echo "run the main main installer starting with menu item 2."
    echo "Exiting"
    echo ""
    exit
fi
echo ""
echo ""
echo ""
echo ""
echo "========================================================"
echo "Android Kexec blob installer by workdowg@xda"
echo "========================================================"
echo ""
echo ""
echo ""
echo "Installing Kexec blob"
echo "Flashing Kexec.blob to mmcblk0p4..."
dd if=kexec.blob of=/dev/block/mmcblk0p4
echo "Kexec blob flashed"
echo ""
echo ""
echo "Android Kexec blob installer - Done!"
echo ""
echo ""
#kexecboot Android kernel install
#Test for correct directory
if [ ! -d "CROMi-X_that10/" ] ; then
	echo "You are not running this script"
    echo "from the correct directory. You will need to"
    echo "run the main installer again starting with menu item 3."
    echo "Exiting"
    echo ""
    exit
fi
echo ""
echo ""
echo ""
echo ""
echo "========================================================"
echo "Android Kexec kernel installer by workdowg@xda"
echo "========================================================"
echo ""
echo ""
echo "Please make a selection"
echo ""
echo ""
echo ""
echo "1 - CROMi-X that10 kernel"
echo "2 - CROMi-X stock kernel"
echo "3 - CROMBi-KK - that10cm11 kernel"
echo "4 - CROMBi-KK - hardslog Grimlock"
echo "5 - CROMBi-KK - stock cm11 kernel"
echo "Any other key exits"
read kernel_ver
echo "Mounting /system r/w..."
mount -o remount,rw -t ext4 /dev/block/mmcblk0p1 /system || echo "/system not mounted r/w"
mkdir -p /system/boot
case $kernel_ver in
    1) cp CROMi-X_that10/* /system/boot/ ;;
    2) cp CROMi-X_Stock/* /system/boot/ ;;
    3) cp CROMBi-KK_that10/* /system/boot/ ;;
    4) cp CROMBi-KK_grim/* /system/boot/ ;;
    5) cp CROMBi-KK_Stock/* /system/boot/ ;;
    *) mount -o remount,ro -t ext4 /dev/block/mmcblk0p1 /system || echo "/system not mounted r/o"
    echo ""
    echo "You will now need to"
    echo "run the main installer again starting with menu item 3."
    echo ""    
    exit 1
esac
echo "Remount /system r/o..." 
mount -o remount,ro -t ext4 /dev/block/mmcblk0p1 /system || echo "/system not mounted r/o"
echo ""
echo ""
echo "Android Kexec kernel installer - Done!"
echo ""
#rootfs install
#show busybox version
bb_ver=$(busybox|head -n1|cut -d " " -f2)
echo ""
echo "************************************"
echo "   Your Busybox version is:"
echo "   $bb_ver"
echo ""
echo "   You need at least 1.22.1"
echo "   to use this installer."
echo "   Press enter to continue, ctl+c to exit"
echo ""
echo "************************************"
echo ""
read
echo "************************************"
echo ""
use_lzma=$(ls ./*.lzma|wc -w)
if [ "$use_lzma" != "1" ] ; then
    echo "Exiting..."
    echo ""
    echo "Please make sure you place ONLY ONE"
    echo "rootfs.tar.lzma file in your install"
    echo "directory. Remove any others"
    echo "and You will now need to"
    echo "run the main installer again starting with menu item 4."
    echo ""
    echo "Enter to continue"
    read
    exit 1
fi
lzma_name=$(ls *.lzma)
echo ""
echo "   Using: $lzma_name for install"
echo ""
#set rootfs image name
echo ""
echo "************************************"
echo "Current rootfs image files (if any)"
echo ""
ls $kit
echo ""
echo "   Enter rootfs image name"
echo "   (ie my_lubuntu_may_14.img)"
echo "   Make sure this name is unique"
echo "   And include the .img at the end"
echo ""
echo "   The default boot.cfg entry is"
echo "   rootfs.img, use this if you do"
echo "   not want to modify the boot.cfg file."
echo ""
echo "************************************"
echo ""
echo ""
echo ""
read rootfs_name
#check for valid entry
if [ "$rootfs_name" == "" ] ; then
	echo "Invalid input. you will now need to"
    echo "run the main installer again starting with menu item 4."
	echo ""
	exit 1
fi
echo ""
#add extension if missed
correctext="$(echo "$rootfs_name" | rev | cut -d"." -f 1 | rev)"
if [ "$correctext" != "img" ] ; then
	rootfs_name="$(echo "$rootfs_name"| cut -d"." -f 1)".img
fi
#check if image name exists
if [ -f "$kit/$rootfs_name" ] ; then
    echo "File exists!"
    echo "Please run the main installer again, menu item 4"
    echo " and type a UNIQUE name carefully."
    echo ""
    echo "Here are the current image names:"
    echo ""
    ls $kit/
    echo "Enter to continue"
    read
    exit 1
fi
#check for internalsd space
inter_a=$(df /data | awk 'NR==2{print$4}'|tail -c 2)
inter_b=$(df /data | awk 'NR==2{print$4}')
inter_c=${inter_b%.*}
if [ ! $inter_a = "G" ] ; then
	echo "You have less than 1GB of free"
	echo "on your internal SD"
	echo "You will need to make room for"
	echo "the installer to work. Minimum is"
	echo "4GB. You only have $inter_b"
	echo ""
	echo "After clearing space, you will need to"
    echo "run the main installer again starting with menu item 4."
    echo ""
    echo "Press enter to continue..."
    echo ""
	read
	exit 1
fi
if [ "$inter_c" -lt "4" ] ; then
	echo "You have less than 4GB of free"
	echo "on your internal SD"
	echo "You will need to make room for"
	echo "the installer to work. Minimum is"
	echo "4GB. You only have $inter_b"
	echo ""
	echo "After clearing space, you will need to"
    echo "run the main installer again starting with menu item 4."
    echo ""
    echo "Press enter to continue..."
    echo ""
	read
	exit 1
fi
#select rootfs image size
#select rootfs image size
if grep -q crombi < /system/build.prop ; then
	rootfs_size=3
	else
	echo ""
	echo "************************************"
	echo ""
	echo "   Space avialable on Internal SD:"
	echo "   $inter_b"
	echo ""
	echo "   Select desired rootfs image size"
	echo ""
	echo "   1) 3 - GB"
	echo "   2) 4 - GB"
	echo "   3) 5 - GB"
	echo "   4) 10 - GB"
	echo "   5) 20 - GB"
	echo "   Any other key to exit"
	echo ""
	read z
	echo ""
	case $z in
		1) rootfs_size=3 ;;
		2) rootfs_size=4 ;;
		3) rootfs_size=5 ;;
		4) rootfs_size=10 ;;
		5) rootfs_size=20 ;;
		*) echo "Invalid selection, run installer again"
			echo ""
		exit
	esac
fi
#check rootfs image size againt available space
if [ "$rootfs_size" -gt "$inter_c" ] ; then
	echo "Not enough room on the internal sd."
	echo "Internal space= $inter_b , You chose $rootfs_size"
	echo "You will need to"
	echo "run the main installer again starting with menu item 4,"
	echo "and choose a smaller size for the image"
	echo ""
	echo "Press enter to continue"
	read
	exit 1
fi
echo ""
echo ""
echo "************************************"
echo ""
echo "   The installer will now create a new"
echo "   rootfs image file named:"
echo "   $rootfs_name"
echo "   in $kit"
echo "   Image size is: $rootfs_size GB"
echo ""
echo "   Press enter to continue, ctl+c to exit"
echo ""
echo "************************************"
read
START=$(date +%s)
echo ""
echo "   Creating Image flie..."
echo ""
echo "************************************"
echo ""
#mount system rw
mount -o remount,rw -t ext4 /dev/block/mmcblk0p1 /system
#create image file
busybox dd if=/dev/zero of="$kit"/"$rootfs_name" bs=1048576 seek="$rootfs_size"000 count=0 || echo "File created anyway"
echo ""
echo "Formating image file..."
echo ""
if grep -q crombi < /system/build.prop ; then
	mke2fs -F -t ext4 "$kit"/"$rootfs_name"
	else
	busybox mke2fs -F "$kit"/"$rootfs_name"
fi
#mount loop device
echo ""
echo "Mounting loop device..."
echo ""
if [ -b /dev/block/loop250 ]; then
	echo "Loop device exists"
else
busybox mknod /dev/block/loop250 b 7 250
fi
echo ""
busybox losetup /dev/block/loop250 "$kit"/"$rootfs_name"
busybox mount -t ext4 /dev/block/loop250 $mnt
echo "   Copying rootfs files to image"
echo "   ~10-30 minutes..."
cd $mnt
tar -ahxf "$installer_path"/"$lzma_name"
cd "$installer_path"
echo ""
echo "********************************"
echo ""
echo "   Rootfs copy done. "
echo ""
FINISH=$(date +%s)
echo "total rootfs install time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"
echo ""
echo "   Unmounting image..."
sleep 15
busybox umount $mnt
busybox losetup -d /dev/block/loop250 || echo "Loop device not disassociated, Please reboot before using rootfs installer again."
mount -o remount,ro -t ext4 /dev/block/mmcblk0p1 /system
#add boot.cfg
mkdir -p /data/media/0/kexecbootcfg
mount -t vfat /dev/block/mmcblk0p5 /data/media/0/kexecbootcfg/
echo ""
echo " Installing boot.cfg..."
echo ""
mkdir -p /data/media/0/kexecbootcfg/multiboot/
echo '#Auto entry from rootfs installer script - 1st install#' > /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo '#Android#' >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "LABEL=CROMi-X or CROMBi-KK" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "BOOT=3" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "DEVICE=/dev/mmcblk0p1" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "DIR=/" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "KERNEL=/boot/zImage" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "INITRD=/boot/initrd.img" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "PRIORITY=100" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo '#Auto entry from rootfs installer script#' >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "LABEL=$rootfs_name file on /data/media/linux" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "BOOT=7" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "DEVICE=/dev/mmcblk0p8" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "IMAGE=/media/linux/$rootfs_name" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "KERNEL=/boot/zImage" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "INITRD=/boot/initrd.img" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo "PRIORITY=99" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
echo ""
echo ""
echo ""
echo ""
echo "Waiting for sync..."
sleep 10
umount /data/media/0/kexecbootcfg/
rm -r /data/media/0/kexecbootcfg/
echo ""
echo "   Boot.cfg installed..."
echo ""
echo "    Install complete."
echo ""
echo "   The kexecboot kernel, Android kexec kernel, a boot.cfg and"
echo "   a rootfs named : $kit/$rootfs_name"
echo "   have been installed."
echo ""
echo "   You can now reboot and profit!"


