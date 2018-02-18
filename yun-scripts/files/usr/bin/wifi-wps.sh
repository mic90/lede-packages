#!/bin/sh

UCI="/sbin/uci"
WPA="/usr/sbin/wpa_cli"
WPA_CONF="/var/run/wpa_supplicant-wlan0.conf"
TEMP_SSID="TEMP_SSID"
TEMP_PASS="TEMP_PASS"

function getSsid {
	local ssid=$(cat $WPA_CONF | grep ssid | grep -o '".*"' | sed 's/"//g' | sed '/^\s*$/d' | sed -e 's/\<TEMP_SSID\>//g' | sed '/^\s*$/d')
	echo "$ssid"
}

function getPass {
	local pass=$(cat $WPA_CONF | grep psk | grep -o '".*"' | sed 's/"//g' | sed '/^\s*$/d' | sed -e 's/\<TEMP_PASS\>//g' | sed '/^\s*$/d')
	echo "$pass"
}

function startWps {
	echo "Restarting WiFi in STA mode..."

	$UCI set "wireless.radio0.channel=auto"
	$UCI set "wireless.@wifi-iface[0].mode=sta"
	$UCI set "wireless.@wifi-iface[0].ssid=TEMP_SSID"
	$UCI set "wireless.@wifi-iface[0].key=TEMP_PASS"
	$UCI set "wireless.@wifi-iface[0].encryption=none"
	$UCI delete "network.lan.ipaddr"
	$UCI delete "network.lan.netmask"
	$UCI set "network.lan.proto=dhcp"
	$UCI set "dhcp.@dnsmasq[0].interface=lo"
	$UCI commit 

	wifi

	echo "Done, waiting 10s for WPS..."

	sleep 10
	$WPA -p /var/run/wpa_supplicant/ wps_pbc

	echo "WPS enabled, waiting 60s..."
	sleep 60
}

function startAp {
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
}

startWps
# After 120s we can check if there are any settings saved in wpa_supplicant
CURR_SSID=$(getSsid)
CURR_PASS=$(getPass)

echo "SSID: $CURR_SSID"
echo "PSK : $CURR_PASS"

# If we are connected with any network save details in uci
if [ -n "$CURR_SSID" ]; then
	echo "Connected with network $CURR_SSID. Saving details"
	$UCI set "wireless.@wifi-iface[0].ssid=$CURR_SSID"
	$UCI set "wireless.@wifi-iface[0].key=$CURR_PASS"
	$UCI set "wireless.@wifi-iface[0].encryption=psk2"
	$UCI commit
	wifi

	echo "Done, exiting.."
	exit 0
fi

# No network was connected, revert to AP mode
if [ -z "$VAR" ]; then
	echo "Unable to connect with any network, reverting to AP mode..."
	startAp
	exit 1
fi

