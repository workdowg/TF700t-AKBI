
=======
TF700t-AKBI v2.6.8 - Final
===========

TF700t Android Kexecboot Installer Script

This installer script allows you to go through a kexecboot and
rootfs install running from an Android terminal. 

**If this is your first install, you only need to run menu item 1**

Menu items 5 and 6 are now optional. Choice 5 installs the default boot.cfg
 sample file, or can restore a backup named boot.cfg.old from the install
 directory. Choice 6 allows you to modify the boot.cfg
 from an Android text editor (Jota).

And although the scripts have some error checking, be
 sure, as always, to make sure you have a current backup... 


**Prerequisites:**

1- A working CROMi-X 5.4 w/ that10, Zombi-Pop or KatKiss install
 on INTERNAL SD (no f2fs,data2fs or rom2sd)

2- A terminal emulator app (tested on Android Terminal Emulator)

3- Text editor (tested on Jota Editor - Not Jota+)

4- Script must be run from the extracted directory

5- Rootfs installer - USE ONLY ONE rootfs.tar.lzma file and
 it must be in installer directory


**Running this script:**

1- Download the latest zip here - http://forum.xda-developers.com/showthread.php?t=2387133

2- Extract to /sdcard or your favorite place

3- Place **ONE** "rootfs.tar.lzma" file in the extracted directory, example files here - http://forum.xda-developers.com/showthread.php?t=2387133

4- Open terminal and get root - su

5- cd to the directory you extracted the installer to

6- Run the script - sh TF700t-AKBI.sh (For a first time install select menu item 1)

7- Follow the prompts

Profit!

**Running the installer for the first time:**

*If you are using KitKat (CROMBi-KK), the rootfs installer will only make a 3GB image file. If you need a bigger image you will need to use one of the Aroma recovery based installers.*

1) Copy a "rootfs.tar.lzma" file (see examples below) to the directory you extracted the
installer to (ex. - /sdcard/TF700t-AKBI-v2.X.X/ ). There can only be **ONE** "rootfs.tar.lzma" file in the install directory at one time.

2) Using an Android terminal (suggest Android Terminal Emulator from the Playstore)
cd into the installer directory (ex. - cd /sdcard/TF700t-AKBI-v2.X.X/ ) and become superuser (su)

3) Run the script - (sh TF700t-AKBI.sh)

4) Choose menu item 1 reading carefully and follow prompts

5) Reboot and profit

After you reboot it will bring you directly to the kexecboot menu which will have 2 choices:
Android and your new rootfs. The kexecboot menu will time out after 10 seconds and boot to
the highest priority OS (default is Android). To choose an OS to boot, use either the volume
keys or dock arrow keys and select with the power button or dock enter key.


**Using after install - Advanced users:**

Installer menu item 4 allows you to install a boot.cfg from the installer directory. This can be any file named boot.cfg or boot.cfg.old (your backup file)

Installer menu item 5 gives the opportunity to manually edit boot.cfg using a text editor (installer pauses while you switch to a text editor)

=======

Credits:

_that@xda kernel zImage and initrd.img files (latest source code: https://github.com/that1/android_kernel_asus_tf700t.git or forked at https://github.com/workdowg/android_kernel_asus_tf700t.git) files where extracted from _that@xda's that10 and (that10cm CROMBi-KK) kernel blobs with no other modifications.

hardslog@xda kernel zImage and initrd.img files (latest source code: https://github.com/Hardslog/grimlock_kernel_asus_tf700t or forked at https://github.com/workdowg/grimlock_kernel_asus_tf700t) files where extracted from hardslog@xda's grimcm111 CROMBi-KK kernel blobs with no other modifications.

JoinTheRealms@xda, moreD_cn@xda and cogano@xda for their work on the kexec.blob. Current kexec.blob is courtesy of cogano@xda and includes a 10 sec time out to default to the PRIORITY=100 boot.cfg choice(moreD_CN@xda source code: https://github.com/cogano/kexecboot.git or forked at https://github.com/workdowg/kexecboot.git)

_sbdags@xda For his work on CROMi-X CROMBi-KK

