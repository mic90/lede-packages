#!/bin/sh

UCI=/sbin/uci

        echo "Restarting Wifi in AP mode..."

        SSID_SUFFIX=`/sbin/ifconfig wlan0 | /usr/bin/head -n 1 | /bin/grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | /bin/sed 's/://g'`
        SSID="HW-$SSID_SUFFIX"

        echo "New SSID = $SSID"

        $UCI set "wireless.radio0.channel=11"
        $UCI set "wireless.@wifi-iface[0].mode=ap"
        $UCI set "wireless.@wifi-iface[0].ssid=$SSID"
        $UCI set "wireless.@wifi-iface[0].encryption=none"
        $UCI delete "wireless.@wifi-iface[0].key"
        $UCI delete "wireless.radio0.country"

        $UCI set "network.lan.ipaddr=192.168.240.1"
        $UCI set "network.lan.netmask=255.255.255.0"
        $UCI set "network.lan.proto=static"

        PREVIOUS_DNSMASQ_IFACE_LIST=`$UCI get "dhcp.@dnsmasq[0].interface"`
        $UCI del_list "dhcp.@dnsmasq[0].interface=$PREVIOUS_DNSMASQ_IFACE_LIST"
        $UCI add_list "dhcp.@dnsmasq[0].interface=lo,wlan0"

        $UCI commit

        wifi

        echo "Done."


