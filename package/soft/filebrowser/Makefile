#
# Copyright (C) 2020 Project OpenWrt
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE.txt for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=filebrowser
PKG_VERSION:=2.18.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/filebrowser/filebrowser/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=7e0a0cb6a8d75d630293baeb009df6cceba3daca60ad622a127c8ed96a40a4d8

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=CN_SZTL <cnsztl@project-openwrt.eu.org>

PKG_CONFIG_DEPENDS:= \
	CONFIG_FILEBROWSER_COMPRESS_UPX

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/filebrowser/filebrowser
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG).build=OpenWrt \
	$(GO_PKG).version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/filebrowser
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Web File Browser which can be used as a middleware or standalone app.
  URL:=https://github.com/filebrowser/filebrowser
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/filebrowser/description
  filebrowser provides a file managing interface within a specified directory
  and it can be used to upload, delete, preview, rename and edit your files.
  It allows the creation of multiple users and each user can have its own directory.
  It can be used as a standalone app or as a middleware.
endef

define Package/filebrowser/config
menu "filebrowser Configuration"
	depends on PACKAGE_filebrowser

config FILEBROWSER_COMPRESS_UPX
	bool "Compress executable files with UPX"
	default y
endmenu
endef

define Build/Compile
( \
  cd $(PKG_BUILD_DIR)/frontend ; \
  npm ci; \
  npm run lint ; \
  npm run build ; \
  GOOS=$$$$(go env GOOS) GOARCH=$$$$(go env GOARCH) GO111MODULE=off go get -v github.com/GeertJohan/go.rice/rice/... ; \
  cd $(PKG_BUILD_DIR)/http ; \
  "$$$$(go env GOPATH)/bin/rice" embed-go ; \
  $(call GoPackage/Build/Compile) ; \
)
ifneq ($(CONFIG_FILEBROWSER_COMPRESS_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/filebrowser
endif
endef

define Package/filebrowser/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/filebrowser $(1)/usr/bin/
endef

$(eval $(call GoBinPackage,filebrowser))
$(eval $(call BuildPackage,filebrowser))
