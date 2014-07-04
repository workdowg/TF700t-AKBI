
=======
TF700t-AKBI v2.5.1
===========

TF700t Android Kexecboot Installer Script

This installer script allows you to go through a kexecboot and
rootfs install. 

If this is your first install, follow the menu
choices in order. And although the scripts have some error
checking, be sure, as always, to make sure you have a current backup... 

This is a menu driven Android terminal based installer. 

You will need the following:

Prerequisites:

1- A working CROMi-X 5.4 w/ that10 or CROMBi-KK install
 on INTERNAL SD (no f2fs,data2fs or rom2sd)

2- A terminal emulator app (tested on Android Terminal Emulator)

3- Text editor (tested on Jota Editor - Not Jota+)

4- Script must be run from the extracted directory

5- Rootfs installer - USE ONLY ONE rootfs.tar.lzma file and
 it must be in installer directory

Running this script:

1- Download the latest zip here - http://forum.xda-developers.com/showthread.php?t=2387133

2- Extract to /sdcard or your favorite place

3- Open emulator and get root - su

4- cd to the directory you extracted this to

5- Run the script - sh TF700t-AKBI.sh

6- Follow the prompts

Profit!

=======

Credits:

_that@xda kernel zImage and initrd.img files (latest source code: https://github.com/that1/android_kernel_asus_tf700t.git or forked at https://github.com/workdowg/android_kernel_asus_tf700t.git) files where extracted from _that@xda's that10 and that10cm kernel blobs with no other modifications.

JoinTheRealms@xda, moreD_cn@xda and cogano@xda for their work on the kexec.blob. Current kexec.blob is courtesy of cogano@xda and includes a 10 sec time out to default to the PRIORITY=100 boot.cfg choice(moreD_CN@xda source code: https://github.com/cogano/kexecboot.git or forked at https://github.com/workdowg/kexecboot.git)

_sbdags@xda For his work on CROMi-X CROMBi-KK

