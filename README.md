openwrt
=
Version:19.07.8

update logs : https://openwrt.org/releases/19.07/changelog-19.07.8

Compilation steps:

**1 Must be installed**

sudo apt-get -y install git build-essential asciidoc flex binutils bzip2 gawk  patch python3 python2.7 zlib1g-dev lib32gcc1 uglifyjs
  
sudo apt-get -y install grep libz-dev perl python3.6 make rsync subversion unzip libc6-dev libc6-dev-i386 gettext libncurses5-dev 

sudo apt-get -y install texinfo libglib2.0-dev xmlto qemu-utils libelf-dev upx autoconf automake libtool autopoint device-tree-compiler

sudo apt-get -y install g++-multilib libssl-dev antlr3 gperf wget curl swig msmtp gcc-multilib p7zip-full


**2 mkdir openwrt**

**3 cd openwrt**

**4 git clone https://github.com/Tonkercke/openwrt.git**

**5 cd openwrt**

**6 ./scripts/feeds update -a**

**7 ./scripts/feeds install -a**

**8 make menuconfig**

**9 make -j1 V=s**
