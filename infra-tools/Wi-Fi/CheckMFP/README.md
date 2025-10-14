# Check_MFP

`check_mfp.sh` is a Bash script that scans nearby Wi-Fi networks and checks their Management Frame Protection (MFP / 802.11w) capabilities.
It determines whether each detected access point:
- Requires MFP (802.11w enforced)
- Supports MFP optionally
- Does not support MFP

The script parses the output of `iw dev <interface> scan` and supports plain text, CSV, or JSON output for easy automation and reporting.

The inspiration from this script came from: https://kevinlocke.name/bits/2019/12/28/checking-802.11w-support/

## Features

- Detects MFP (802.11w) support on all nearby access points
- Displays both BSSID and SSID
- Supports plain text, CSV and JSON output formats

## Requirements

- Linux system with iw installed
- Root privileges
- Wireless adapter in Managed mode

## Install

Clone the Repository or download the `check_mfp.sh`

### Cloning the Repository

```bash
git clone https://github.com/J0nan/RandomThings.git
cd RandomThings/infra-tools/Wi-Fi/CheckMFP
chmod +x check_mfp.sh
# sudo ln -s "$PWD/check_mfp.sh" /usr/bin/check_mfp # To create a symbolic link in order to be called as check_mfp
```

### Downloading the script

```bash
curl -L -o check_mfp.sh https://raw.githubusercontent.com/J0nan/RandomThings/refs/heads/main/infra-tools/Wi-Fi/CheckMFP/check_mfp.sh && chmod +x check_mfp.sh
# sudo ln -s "$PWD/check_mfp.sh" /usr/bin/check_mfp # To create a symbolic link in order to be called as check_mfp
```

## Usage

Run the script as root:

```bash
sudo ./check_mfp.sh <interface> [csv|json]
```

Arguments:

- `<interface>` – Wireless interface name (e.g., wlan0)
- `[csv|json]` – (Optional) Output format. Defaults to human-readable text.
