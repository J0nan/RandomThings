#!/bin/bash

# Authors: J0nan
# Version: 1.0.0
# Description: Scan Wi-Fi networks and show MFP (802.11w) support status on all APs
# Usage:
#   sudo ./check_mfp.sh <interface> [csv|json]

# Validate privileges
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    echo "   Try: sudo $0 <interface> [csv|json]"
    exit 1
fi

IFACE="$1"
FORMAT="$2"

# Validate interface
if [ -z "$IFACE" ]; then
    echo "Usage: $0 <interface> [csv|json]"
    exit 1
fi

if ! iw dev "$IFACE" info &>/dev/null; then
    echo "Interface '$IFACE' not found or not a wireless device."
    exit 1
fi

if [ -n "$FORMAT" ]; then
    echo "Scanning Wi-Fi networks on interface: $IFACE..."
fi

SCAN_OUTPUT=$(iw dev "$IFACE" scan 2>/dev/null)

if [ -z "$SCAN_OUTPUT" ]; then
    echo "No scan results found or the interface is down."
    echo "Check the interface is up and not in monitor mode."
    exit 1
fi

# Parse and output
case "$FORMAT" in
  csv)
    echo "BSSID,SSID,MFP_Status"
    ;;
  json)
    echo "["
    ;;
esac

echo "$SCAN_OUTPUT" | awk -v format="$FORMAT" '
/^BSS / {
    if (bssid != "") {
        if (format == "csv") {
            printf "%s,%s,%s\n", bssid, ssid, (mfp==""?"Not supported":mfp);
        } else if (format == "json") {
            if (count > 0) printf ",\n";
            printf "  {\"BSSID\": \"%s\", \"SSID\": \"%s\", \"MFP_Status\": \"%s\"}", bssid, ssid, (mfp==""?"Not supported":mfp);
            count++;
        } else {
            printf "BSSID: %s\nSSID: %s\n", bssid, ssid;
            if (mfp == "Required")
                print "  MFP: REQUIRED (802.11w enforced)";
            else if (mfp == "Optional")
                print "  MFP: OPTIONAL (802.11w supported)";
            else
                print "  MFP: Not supported";
            print "";
        }
    }
    match($0, /^BSS ([0-9a-f:]+)/, m);
    bssid = (m[1] != "" ? m[1] : "");
    ssid = ""; mfp = "";
}

/^\s*SSID:/ {
    sub(/^[[:space:]]*SSID:[[:space:]]*/, "", $0);
    ssid=$0;
}

/^\s*RSN:/, /^\S/ {
    if ($0 ~ /MFP-required/) mfp="Required";
    else if ($0 ~ /MFP-capable/ && mfp != "required") mfp="Optional";
}

END {
    if (bssid != "") {
        if (format == "csv") {
            printf "%s,%s,%s\n", bssid, ssid, (mfp==""?"Not supported":mfp);
        } else if (format == "json") {
            if (count > 0) printf ",\n";
            printf "  {\"BSSID\": \"%s\", \"SSID\": \"%s\", \"MFP_Status\": \"%s\"}\n]", bssid, ssid, (mfp==""?"Not supported":mfp);
        } else {
            printf "BSSID: %s\nSSID: %s\n", bssid, ssid;
            if (mfp == "Required")
                print "  MFP: REQUIRED (802.11w enforced)";
            else if (mfp == "Optional")
                print "  MFP: OPTIONAL (802.11w supported)";
            else
                print "  MFP: Not supported";
            print "";
        }
    } else if (format == "json") {
        print "]"
    }
}
'
