#!/bin/bash

# Authors: J0nan / n0t4u
# Version: 0.1.0
# Description: Automatic installation of hacking tools on Kali

DEBIAN_FRONTEND=noninteractive

# Source: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# Regular Colors
Red='\033[0;31m'		# Red
Green='\033[0;32m'		# Green
Yellow='\033[0;33m'		# Yellow
Blue='\033[0;34m'		# Blue
ColorOff='\033[0m'		# Text Reset

# Setup
# Configuration of the terminal 
mkdir -p /home/kali/.config/qterminal.org
wget --no-check-certificate -O /home/kali/.config/qterminal.org/qterminal.ini https://raw.githubusercontent.com/J0nan/RandomThings/refs/heads/develop/provisioning/kali/generic/qterminal.ini
wget --no-check-certificate -O /home/kali/.config/qterminal.org/qterminal_bookmarks.xml https://raw.githubusercontent.com/J0nan/RandomThings/refs/heads/develop/provisioning/kali/generic/qterminal_bookmarks.xml
mkdir -p /usr/share/qtermwidget6/color-schemes
cp /usr/share/qtermwidget5/color-schemes/* /usr/share/qtermwidget6/color-schemes/  # Copy the old terminal themes to the new
chown -R kali:kali /home/kali/.config/qterminal.org

# Power manager XFCE in user kali
# Disabling power safe, blank screen and switch-off in the monitor
mkdir -p /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml
wget --no-check-certificate -O /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml https://raw.githubusercontent.com/J0nan/RandomThings/refs/heads/develop/provisioning/kali/generic/xfce4-power-manager.xml
chown -R kali:kali /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml
chmod 664 /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml

# General purpose tools
# Python3 and PIP3
echo -e "${Blue}[*] Installing python3 ${ColorOff}"
apt install python3.12 python3.12-venv -y

# git
echo -e "${Blue}[*] Installing git${ColorOff}"
apt install git -y

# Go
echo -e "${Blue}[*] Installing go and dependencies (BETA)${ColorOff}"
apt install golang-go -y
go env -w GOBIN="/opt/go/bin"
echo -en 'export PATH="$PATH:/usr/local/go/bin:/opt/go/bin"\ngo env -w GOBIN="/opt/go/bin"' >>/etc/profile

# Docker
apt install docker.io -y
systemctl disable docker.service
systemctl disable docker.socket
usermod -a -G docker kali

# Snapd
apt install snapd -y
systemctl enable snapd --now
ln -s /var/lib/snapd/snap /usr/bin/snap

# SecLists
echo -e "${Blue}[*] Downloading dictionaries from SecLists${ColorOff}"
git clone https://github.com/danielmiessler/SecLists.git /opt/SecLists

# Dig and Nslookup
echo -e "${Blue}[*] Installing dnsutils (dig, nslookup)${ColorOff}"
apt install dnsutils -y

# Web applications tools
# Nuclei
echo -e "${Blue}[*] Installing nuclei${ColorOff}"
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Interactsh
echo -e "${Blue}[*] Installing interactsh${ColorOff}"
go install github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest

# Testssl.sh
echo -e "${Blue}[*] Installing testssl${ColorOff}"
git clone https://github.com/drwetter/testssl.sh.git /opt/testssl
ln -s /opt/testssl/testssl.sh /usr/bin/testssl

# wafw00f
echo -e "${Blue}[*] Installing wafw00f${ColorOff}"
apt remove wafw00f -y
pipx install git+https://github.com/EnableSecurity/wafw00f.git
ln -s /.local/share/pipx/venvs/wafw00f/bin/wafw00f /usr/bin/wafw00f

# httpx
echo -e "${Blue}[*] Installing httpx${ColorOff}"
apt remove httpx -y
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

# Dirb
echo -e "${Blue}[*] Installing dirb${ColorOff}"
apt install dirb -y

# Gobuster
echo -e "${Blue}[*] Installing gobuster${ColorOff}"
apt install gobuster -y

# AMASS
echo -e "${Blue}[*] Installing AMASS${ColorOff}"
apt install amass -y

# Subfinder
echo -e "${Blue}[*] Installing subfinder${ColorOff}"
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Arjun
echo -e "${Blue}[*] Installing arjun${ColorOff}"
pipx install arjun
ln -s /.local/share/pipx/venvs/arjun/bin/arjun /usr/bin/arjun

# ffuf
echo -e "${Blue}[*] Installing ffuf${ColorOff}"
apt install ffuf -y 

# Bypass-403
echo -e "${Blue}[*] Installing Bypass-403${ColorOff}"
git clone https://github.com/iamj0ker/bypass-403 /opt/bypass-403
chmod +x /opt/bypass-403/bypass-403.sh
ln -s /opt/bypass-403/bypass-403.sh /usr/bin/bypass-403

# Corsy
echo -e "${Blue}[*] Installing Corsy${ColorOff}"
git clone https://github.com/s0md3v/Corsy /opt/corsy
python3 -m venv /opt/corsy
/opt/corsy/bin/python /opt/corsy/bin/pip install -r /opt/corsy/requirements.txt
chmod +x /opt/corsy/corsy.py
ln -s /opt/corsy/corsy.py /usr/bin/corsy

# EyeWitness
echo -e "${Blue}[*] Installing EyeWitness${ColorOff}"
apt install eyewitness -y

# Aquatone
echo -e "${Blue}[*] Installing Aquatone${ColorOff}"
git clone https://github.com/firefart/aquatone.git /opt/aquatone
go build -buildvcs=false /opt/aquatone
ln -s /opt/aquatone/aquatone /usr/bin/aquatone

# Infrastructure tools
# Onesixtyone (SNMP)
echo -e "${Blue}[*] Installing onesixtyone${ColorOff}"
apt remove onesixtyone -y
git clone https://github.com/trailofbits/onesixtyone.git /opt/onesixtyone
gcc -o /opt/onesixtyone/onesixtyone /opt/onesixtyone/onesixtyone.c
ln -s /opt/onesixtyone/onesixtyone /usr/bin/onesixtyone

# dnsrecon
echo -e "${Blue}[*] Installing dnsrecon${ColorOff}"
apt install dnsrecon

# domain_analyzer
echo -e "${Blue}[*] Installing domain_analyzer${ColorOff}"
git clone https://github.com/eldraco/domain_analyzer.git /opt/domain_analyzer
python3 -m venv /opt/domain_analyzer
/opt/domain_analyzer/bin/python /opt/domain_analyzer/bin/pip install -r /opt/domain_analyzer/requirements.txt
chmod +x /opt/domain_analyzer/domain_analyzer.py
ln -s /opt/domain_analyzer/domain_analyzer.py /usr/bin/domain_analyzer

# dnsmasq
echo -e "${Blue}[*] Installing dnsmasq${ColorOff}"
apt install dnsmasq -y

# SSH-Audit
echo -e "${Blue}[*] Installing ssh-audit${ColorOff}"
git clone https://github.com/jtesta/ssh-audit /opt/ssh-audit
chmod +x /opt/ssh-audit/ssh-audit.py
ln -s /opt/ssh-audit/ssh-audit.py /usr/bin/ssh-audit

# Terrapin-Scanner
echo -e "${Blue}[*] Installing Terrapin-Scanner${ColorOff}"
go install github.com/RUB-NDS/Terrapin-Scanner@latest

# JexBoss
echo -e "${Blue}[*] Installing JexBoss${ColorOff}"
git clone https://github.com/joaomatosf/jexboss.git /opt/jexboss
python3 -m venv /opt/jexboss
/opt/jexboss/bin/python /opt/jexboss/bin/pip install -r /opt/jexboss/requires.txt
ln -s /opt/jexboss/jexboss.py /usr/bin/jexboss

# SSLScan
echo -e "${Blue}[*] Installing SSLScan${ColorOff}"
apt install sslscan -y

# Mobile Tools
# Jadx
echo -e "${Blue}[*] Installing jadx${ColorOff}"
apt install jadx -y

# Google Android Tools
echo -e "${Blue}[*] Installing Google Android Tools${ColorOff}"
apt install google-android-platform-tools-installer -y

# WiFi tools
# Airgeddon
echo -e "${Blue}[*] Installing Airgeddon${ColorOff}"
git clone --depth 1 https://github.com/v1s1t0r1sh3r3/airgeddon.git /opt/airgeddon
chmod +x /opt/airgeddon/airgeddon.sh
ln -s /opt/airgeddon/airgeddon.sh /usr/bin/airgeddon

# Cracking
# COOK
echo -e "${Blue}[*] Installing COOK${ColorOff}"
go install github.com/glitchedgitz/cook/v2/cmd/cook@latest
