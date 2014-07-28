#!/system/bin/sh
#Android Kexecboot Rootfsboot.cfg Installer - TF700t-AKBI v2.5.6
# 07/28/2014
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
#Test for correct directory
if [ ! -f boot.cfg ] ; then
    echo "You are not running this script"
    echo "from the correct directory. Exiting"
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
echo "*   Linux Rootfs Installer "
echo "*    for the TF700t"
echo "************************************"
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
    echo "and run installer again."
    echo ""
    echo "Enter to continue"
    read
    sh ./TF700t-AKBI.sh
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
echo ""
#check if image name exists
if [ -f "$kit/$rootfs_name" ] ; then
    echo "File exists!"
    echo "Please choose the installer again"
    echo " and type a UNIQUE name carefully."
    echo ""
    echo "Enter to continue"
    read
    sh ./TF700t-AKBI.sh
fi
internalsd_free=$(df /data | awk 'NR==2{print$4}'| sed 's/.$//')
echo ""
echo "************************************"
echo ""
echo "   Space avialable on Internal SD:"
echo "   $internalsd_free GB"
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
    *) sh ./TF700t-AKBI.sh
esac
if [ "$rootfs_size" -gt "$internalsd_free" ]
	then echo "Not enough room on internal sd. Choose installer"
	echo "again and choose a smaller size for the image"
	echo ""
	echo "Press enter to continue"
	read
	sh ./TF700t-AKBI.sh
fi
#write entry to boot.cfg?
echo "" 
echo "   How would you like to write this new "
echo "    entry into the boot.cfg?"
echo "   1) Write new boot.cfg"
echo "   2) Add entry to end (CAUTION !! MUST HAVE A boot.cfg ALREADY INSTALLED!!)"
echo "   3) Continue without modifing"
echo ""
read n
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
busybox dd if=/dev/zero of="$kit"/"$rootfs_name" seek=1G bs="$rootfs_size" count=0
echo ""
echo "Formating image file..."
echo ""
busybox mke2fs -F "$kit"/"$rootfs_name"
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
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"
echo ""
echo "   Unmounting image..."
sleep 15
busybox umount $mnt
busybox losetup -d /dev/block/loop250 || echo "Loop device not disassociated, Please reboot before using rootfs installer again."
mount -o remount,ro -t ext4 /dev/block/mmcblk0p1 /system
#boot.cfg modify/add
case $n in
    1)  mkdir -p /data/media/0/kexecbootcfg
		mount -t vfat /dev/block/mmcblk0p5 /data/media/0/kexecbootcfg/
		echo "Backing up boot.cfg..."
		if [ -e /data/media/0/kexecbootcfg/multiboot/boot.cfg ]
		then cp /data/media/0/kexecbootcfg/multiboot/boot.cfg boot.cfg.old
		fi
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
		echo "Copying new boot.cfg..."
		echo ""
		echo ""
		echo "Waiting for sync..."
		sleep 10
		umount /data/media/0/kexecbootcfg/
		rm -r /data/media/0/kexecbootcfg ;;
	2) mkdir -p /data/media/0/kexecbootcfg
		mount -t vfat /dev/block/mmcblk0p5 /data/media/0/kexecbootcfg/
		echo "Backing up boot.cfg..."
		if [ -e /data/media/0/kexecbootcfg/multiboot/boot.cfg ]
		then cp /data/media/0/kexecbootcfg/multiboot/boot.cfg boot.cfg.old
		getpriority="$(grep -F "PRIORITY=" /data/media/0/kexecbootcfg/multiboot/boot.cfg|cut -d"=" -f 2|sort -n|head -1)"
		setpriority="$(expr $getpriority - 1)"
		fi
		mkdir -p /data/media/0/kexecbootcfg/multiboot/
		echo "" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo '#Auto entry from rootfs installer script - added#' >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo "LABEL=$rootfs_name file on /data/media/linux" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo "BOOT=7" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo "DEVICE=/dev/mmcblk0p8" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo "IMAGE=/media/linux/$rootfs_name" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo "KERNEL=/boot/zImage" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo "INITRD=/boot/initrd.img" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo "PRIORITY=$setpriority" >> /data/media/0/kexecbootcfg/multiboot/boot.cfg
		echo ""
		echo ""
		echo "Copying new boot.cfg..."
		echo ""
		echo ""
		echo "Waiting for sync..."
		sleep 10
		umount /data/media/0/kexecbootcfg/
		rm -r /data/media/0/kexecbootcfg ;;
    3)  echo ""
		echo "   Boot.cfg not modified"
		echo ""
		echo "   Don't forget to run the Boot.cfg installer"
		echo "   and or Modifiier if needed"
		echo "   and add your new rootfs:"
		echo ""
		echo "   $kit/$rootfs_name"
		echo ""
		echo "   Press enter to continue"
		read
		sh ./TF700t-AKBI.sh ;;
    *)  echo ""
		echo "   Boot.cfg not modified"
		echo ""
		echo "   Don't forget to run the Boot.cfg installer"
		echo "   and or Modifiier if needed"
		echo "   and add your new rootfs:"
		echo ""
		echo "   $kit/$rootfs_name"
		echo ""
		echo "   Press enter to continue"
		read
		sh ./TF700t-AKBI.sh
esac 
echo ""
echo "   Done."
echo ""
echo "   Your rootfs named : $kit/$rootfs_name"
echo "   has been installed and a boot.cfg"
echo "   was added or modified"
echo ""
echo ""
echo "   Press enter to continue"
read
sh ./TF700t-AKBI.sh
