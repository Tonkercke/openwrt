include $(TOPDIR)/rules.mk

PKG_NAME:=Command
PKG_VERSION:=0.1
PKG_RELEASE:=$(AUTORELEASE)

define Package/Command/template
  TITLE:=Change network MAC
  SECTION:=net
  CATEGORY:=Network
endef

define Package/Command/install
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DATA) $(CURDIR)/files/ch_ap_mac.sh $(1)/etc/config/scp/
	$(INSTALL_DATA) $(CURDIR)/files/ap_mac.txt $(1)/etc/config/scp/
	$(INSTALL_DATA) $(CURDIR)/files/ch_mac.sh $(1)/etc/config/scp/
	$(INSTALL_DATA) $(CURDIR)/files/mac.txt $(1)/etc/config/scp/

endef

$(eval $(call BuildPackage,Command))
