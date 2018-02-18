#
# Copyright (c) 2013 Arduino LLC. All right reserved.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=yun-scripts
PKG_VERSION:=1.3
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

define Package/yun-scripts
  SECTION:=utils
  CATEGORY:=Base system
  TITLE:=Custom Yún scripts
  DEPENDS:=+kmod-loop +kmod-spi-gpio-custom +kmod-usb-storage +kmod-scsi-core +kmod-scsi-generic +kmod-fs-msdos +gnupg +libiwinfo-lua
endef

define Build/Compile
	# NOOP
endef

define Package/yun-scripts/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d

	$(INSTALL_BIN) ./files/usr/bin/blink-start $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/blink-stop $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/boot-complete-notify $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/run-sysupgrade $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/run-avrdude $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/merge-sketch-with-bootloader.lua $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/wifi-reset-button-pressed $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/wifi-reset-button-released $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/wifi-sta $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/wifi-wps $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/reset-mcu $(1)/usr/bin/
	$(INSTALL_BIN) ./files/usr/bin/pretty-wifi-info.lua $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/extract-built-date $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/extract-built-date-from-sysupgrade-image $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/get-gpio-conf $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/internet-check $(1)/usr/bin

	$(INSTALL_BIN) ./files/etc/init.d/generate_new_gpg_key $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/enable-rngd $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/rngd-turn-off $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/avahi-update-config $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/create-spi-gpio $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/internet-check-service $(1)/etc/init.d
endef

$(eval $(call BuildPackage,yun-scripts))

