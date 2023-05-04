openwrt
=
Version:22.03-2023-0405

Compilation steps:

**1 Must be installed**

sudo apt install -y subversion g++ zlib1g-dev build-essential git python3 flex uglifyjs gcc-multilib msmtp texinfo autoconf automake libtool autopoint device-tree-compiler 2to3   python2 dh-python

sudo apt install -y libfuse-dev libncurses5-dev gawk gettext unzip file libssl-dev wget asciidoc binutils g++-multilib antlr3 gperf swig rsync

sudo apt install -y libelf-dev ecj fastjar java-propose-classpath bzip2 patch lib32gcc-s1 libc6-dev-i386 libglib2.0-dev xmlto qemu-utils upx-ucl curl npm


**2 mkdir openwrt**

**3 cd openwrt**

**4 git clone https://github.com/Tonkercke/openwrt.git**

**5 cd openwrt**

**6 ./scripts/feeds update -a**

**7 ./scripts/feeds install -a**

**8 make menuconfig**

**9 make -j1 V=s**
