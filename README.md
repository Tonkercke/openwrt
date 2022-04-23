openwrt
=
Version:21.02.3

Changelog:https://openwrt.org/releases/21.02/changelog-21.02.3

Compilation steps:

**1 Must be installed**

sudo apt install -y subversion g++ zlib1g-dev build-essential git python python3 flex libz-dev  uglifyjs gcc-multilib msmtp texinfo autoconf automake libtool autopoint device-tree-compiler

sudo apt install -y libncurses5-dev gawk gettext unzip file libssl-dev wget asciidoc binutils g++-multilib antlr3 gperf swig rsync

sudo apt install -y libelf-dev ecj fastjar java-propose-classpath bzip2 patch lib32gcc1 libc6-dev-i386 libglib2.0-dev xmlto qemu-utils upx curl npm


**2 mkdir openwrt**

**3 cd openwrt**

**4 git clone https://github.com/Tonkercke/openwrt.git**

**5 cd openwrt**

**6 ./scripts/feeds update -a**

**7 ./scripts/feeds install -a**

**8 make menuconfig**

**9 make -j1 V=s**
