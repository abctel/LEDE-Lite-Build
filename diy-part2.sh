#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改默认IP
sed -i 's/192.168.1.1/192.168.100.200/g' package/base-files/files/bin/config_generate

# 增加关机插件
#git clone https://github.com/esirplayground/luci-app-poweroff.git package/lean/uci-app-poweroff

# 增加Chinadns-NG插件
#git clone https://github.com/abctel/openwrt-chinadns-ng package/abctel/luci-app-chinadns-ng
# 增加dnscrypt-proxy2插件并替换默认插件
#git clone https://github.com/abctel/dnscrypt-proxy2 abctel/dnscrypt-proxy2
#rm -rf feeds/packages/net/dnscrypt-proxy2/*
#mv -f abctel/dnscrypt-proxy2/* feeds/packages/net/dnscrypt-proxy2/

# 配置定制
#mkdir abctel
#git clone https://github.com/abctel/LEDE-Firmware-Config.git abctel/config

#mv -f abctel/config/passwall package/feeds/kenzo/luci-app-passwall/root/etc/config/passwall

#mkdir package/feeds/kenzo/luci-app-smartdns/root/etc/smartdns
#mv -f abctel/config/custom.conf package/feeds/kenzo/luci-app-smartdns/root/etc/smartdns/custom.conf
#mkdir package/feeds/kenzo/luci-app-smartdns/root/etc/config
#mv -f abctel/config/smartdns package/feeds/kenzo/luci-app-smartdns/root/etc/config/smartdns
#mv -f abctel/config/AdGuardHome.yaml package/feeds/kenzo/luci-app-adguardhome/root/etc/config/AdGuardHome.yaml
#mkdir package/feeds/kenzo/luci-app-adguardhome/root/usr/bin
#touch package/feeds/kenzo/luci-app-adguardhome/root/usr/bin/AdGuardHome
#mv -f abctel/config/update_core.sh package/feeds/kenzo/luci-app-adguardhome/root/usr/share/AdGuardHome/update_core.sh
#mv -f abctel/config/AdGuardHome_template.yaml package/feeds/kenzo/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml


# 增加一套主题
#git clone https://github.com/siropboy/luci-theme-btmod package/lean/luci-theme-btmod

# 删除老argon主题
# rm -rf package/lean/luci-theme-argon

# 拉取argon主题
# git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# Del Path
rm -rf feeds/packages/net/dnscrypt-proxy2
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/packages/net/smartdns
# luci-app-SmartDNS
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns.git package/abctel/luci-app-smartdns
# dnscrypt-proxy2
git clone --depth=1 https://github.com/abctel/dnscrypt-proxy2.git feeds/packages/net/dnscrypt-proxy2
# Passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/abctel/passwall
rm -rf package/abctel/passwall/chinadns-ng
mv -f package/abctel/passwall/* package/abctel/
rm -rf package/abctel/passwall/
# ChinaDNS-NG
#git clone --depth=1 https://github.com/pexcn/openwrt-chinadns-ng.git package/abctel/chinadns-ng
# luci-app-ChinaDNS-NG
#git clone --depth=1 -b luci https://github.com/pexcn/openwrt-chinadns-ng.git package/abctel/luci-app-chinadns-ng
# AdGuardHome
git clone --depth=1 https://github.com/kenzok8/openwrt-packages.git package/abctel/kenzok
mv -f package/abctel/kenzok/AdGuardHome package/abctel/
mv -f package/abctel/kenzok/luci-app-adguardhome package/abctel/
mv -f package/abctel/kenzok/smartdns package/abctel/
rm -rf package/abctel/kenzok
# dnsmasq-china-list
git clone --depth=1 https://github.com/abctel/abctel-package package/abctel/dcl
mv -f package/abctel/dcl/* package/abctel/
rm -rf package/abctel/dcl
# Del Files
rm package/abctel/chinadns-ng/files/chnroute.txt
rm package/abctel/chinadns-ng/files/chnroute6.txt
rm package/abctel/chinadns-ng/files/gfwlist.txt
rm package/abctel/chinadns-ng/files/chinalist.txt
# update chinadns-ng ip_list
wget https://raw.githubusercontent.com/pexcn/daily/gh-pages/chnroute/chnroute.txt -nv -O package/abctel/chinadns-ng/files/chnroute.txt
wget https://raw.githubusercontent.com/pexcn/daily/gh-pages/chnroute/chnroute-v6.txt -nv -O package/abctel/chinadns-ng/files/chnroute6.txt
wget https://raw.githubusercontent.com/pexcn/daily/gh-pages/gfwlist/gfwlist.txt -nv -O package/abctel/chinadns-ng/files/gfwlist.txt
wget https://raw.githubusercontent.com/pexcn/daily/gh-pages/chinalist/chinalist.txt -nv -O package/abctel/chinadns-ng/files/chinalist.txt
# Config Files
git clone --depth=1 https://github.com/abctel/LEDE-Firmware-Config abctel/config
mv -f abctel/config/Passwall/passwall package/abctel/luci-app-passwall/root/etc/config/passwall
mkdir package/abctel/luci-app-smartdns/root/etc/smartdns
mv -f abctel/config/SmartDNS/custom.conf package/abctel/luci-app-smartdns/root/etc/smartdns/custom.conf
mkdir package/abctel/luci-app-smartdns/root/etc/config
mv -f abctel/config/SmartDNS/smartdns package/abctel/luci-app-smartdns/root/etc/config/smartdns
#mkdir package/abctel/luci-app-adguardhome/root/usr/bin
#touch package/abctel/luci-app-adguardhome/root/usr/bin/AdGuardHome
mv -f abctel/config/AdGuardHome/update_core.sh package/abctel/luci-app-adguardhome/root/usr/share/AdGuardHome/update_core.sh
mv -f abctel/config/AdGuardHome/AdGuardHome.yaml package/abctel/luci-app-adguardhome/root/etc/config/AdGuardHome.yaml
mv -f abctel/config/AdGuardHome/AdGuardHome_template.yaml package/abctel/luci-app-adguardhome/root/usr/share/AdGuardHome/AdGuardHome_template.yaml
rm -rf abctel/
