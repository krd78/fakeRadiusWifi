#! /bin/bash

delete_mon (){
    i=0
    err="0"
    while [ "$err" == "0" ]; do
        echo "Deleting mon$i"
        iw dev mon"$i" del
        err="$?"
        i=`bc <<< $i+1`
    done
}

helper() {
    cat << EOF
$0 <OPTIONS>

OPTIONS:
    -s [name]         SSID name
    -i [interface]      Interface name
    -h                  this help menu
EOF
    exit 0
}

HOSTAPD_CONF=/etc/hostapd/fake_radius.conf
HOSTAP_LOG=/var/log/hostapd.log
SECRET=testing123
RADIUS_DIR=/usr/local/etc/raddb
IP_RADIUS=127.0.0.1
PORT_RADIUS=1812

delete_mon
while [ "$1" != "" ]; do
    if [ "$1" == "-h" -o "$1" == "-help" ]; then
        helper
    fi
    if [ "$1" == "-i" -o "$1" == "--interface" ]; then
        interface=${2:wlan0}
    fi
    if [ "$1" == "-s" -o "$1" == "--ssid" ]; then
        ssid=${2:Radius-Hotspot}
    fi
    shift 2
done

cat > $HOSTAPD_CONF << EOF
interface=$interface
driver=nl80211
ssid=$ssid
logger_stdout=-1
logger_stdout_level=0
dump_file=/tmp/hostapd.dump
ieee8021x=1
eapol_key_index_workaround=0
own_ip_addr=127.0.0.1
auth_server_addr=$IP_RADIUS
auth_server_shared_secret=$SECRET
acct_server_addr=$IP_RADIUS
acct_server_shared_secret=$SECRET
wpa=2
wpa_key_mgmt=WPA-EAP
channel=1
wpa_pairwise=CCMP
#rsn_pairwise=CCMP
EOF
cat > $RADIUS_DIR/clients.conf << EOF
client localhost {
        ipaddr  = 0.0.0.0
        netmask = 0
        secret  = testing123
        nastype = other
}
EOF
airmon-ng start $interface
radiusd -X
err=$?
echo "+ Radius serveur started with code $err."
hostapd $HOSTAPD_CONF &
err=$?
echo "+ Hostapd started with code $err."
