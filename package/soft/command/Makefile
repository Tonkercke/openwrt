include $(TOPDIR)/rules.mk

PKG_NAME:=command
PKG_VERSION:=0.1
PKG_RELEASE:=$(AUTORELEASE)

include $(INCLUDE_DIR)/package.mk

define Package/command
  SECTION:=net
  CATEGORY:=Network
  TITLE:=A tool to change Mac address
endef

define Package/command/install
	$(INSTALL_DIR) $(1)/etc/config/scp/
	$(INSTALL_DATA) $(CURDIR)/files/ch_ap_mac.sh $(1)/etc/config/scp/
	$(INSTALL_DATA) $(CURDIR)/files/ap_mac.txt $(1)/etc/config/scp/
	$(INSTALL_DATA) $(CURDIR)/files/ch_mac.sh $(1)/etc/config/scp/
	$(INSTALL_DATA) $(CURDIR)/files/mac.txt $(1)/etc/config/scp/

endef

$(eval $(call BuildPackage,command))
