#!/bin/bash

# Authors: J0nan / n0t4u
# Version: 0.1.0
# Description: Automatic update of Kali and tools installed

DEBIAN_FRONTEND=noninteractive

# Source: https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# Regular Colors
Red='\033[0;31m'		# Red
Green='\033[0;32m'		# Green
Yellow='\033[0;33m'		# Yellow
Blue='\033[0;34m'		# Blue
ColorOff='\033[0m'		# Text Reset

# Check execution as root
check_privs(){
    if [[ whoami -ne "root" ]]; then
            echo -e "${Red}This script is supposed to be run with sudo privileges${ColorOff}"
            exit 0
    fi
}
check_privs

# Update APT
echo -e "${Blue}[*] Updating APT packages${ColorOff}"
apt update
apt upgrade -y

# Update pipx tools
echo -e "${Blue}[*] Updating pipx packages${ColorOff}"
pipx upgrade-all

# General purpose tools
# Python3 and PIP3
# git
# Go
# Docker
# Snapd
# SecLists
# Dig and Nslookup
## Should be updated via APT

# Web applications tools
# Nuclei
echo -e "${Blue}[*] Updating nuclei${ColorOff}"
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Interactsh
echo -e "${Blue}[*] Updating interactsh${ColorOff}"
go install github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest

# Testssl.sh
echo -e "${Blue}[*] Updating testssl${ColorOff}"
git -C /opt/testssl pull

# wafw00f
## Should be updated via pipx

# httpx
echo -e "${Blue}[*] Updating httpx${ColorOff}"
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

# Dirb
# Gobuster
# AMASS
## Should be updated via APT

# Subfinder
echo -e "${Blue}[*] Updating subfinder${ColorOff}"
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Arjun
## Should be updated via pipx

# ffuf
## Should be updated via APT

# Bypass-403
echo -e "${Blue}[*] Updating Bypass-403${ColorOff}"
git -C /opt/bypass-403 pull

# Corsy
echo -e "${Blue}[*] Updating Corsy${ColorOff}"
git -C /opt/corsy pull
/opt/corsy/bin/python /opt/corsy/bin/pip install -r /opt/corsy/requirements.txt
chmod +x /opt/corsy/corsy.py

# EyeWitness
## Should be updated via APT

# Aquatone
echo -e "${Blue}[*] Updating Aquatone${ColorOff}"
git -C /opt/coaquatonersy pull
go build -buildvcs=false /opt/aquatone

# Infrastructure tools
# Onesixtyone (SNMP)
echo -e "${Blue}[*] Updating onesixtyone${ColorOff}"
git -C /opt/onesixtyone pull
gcc -o /opt/onesixtyone/onesixtyone /opt/onesixtyone/onesixtyone.c

# dnsrecon
## Should be updated via APT

# domain_analyzer
echo -e "${Blue}[*] Updating domain_analyzer${ColorOff}"
git -C /opt/domain_analyzer pull
/opt/domain_analyzer/bin/python /opt/domain_analyzer/bin/pip install -r /opt/domain_analyzer/requirements.txt
chmod +x /opt/domain_analyzer/domain_analyzer.py

# dnsmasq
## Should be updated via APT

# SSH-Audit
echo -e "${Blue}[*] Updating ssh-audit${ColorOff}"
git -C /opt/ssh-audit pull

# Terrapin-Scanner
echo -e "${Blue}[*] Updating Terrapin-Scanner${ColorOff}"
go install github.com/RUB-NDS/Terrapin-Scanner@latest

# JexBoss
echo -e "${Blue}[*] Updating JexBoss${ColorOff}"
git -C /opt/jexboss pull
python3 -m venv /opt/jexboss
/opt/jexboss/bin/python /opt/jexboss/bin/pip install -r /opt/jexboss/requires.txt

# SSLScan
## Should be updated via APT

# Mobile Tools
# Jadx
# Google Android Tools
## Should be updated via APT

# WiFi tools
# Airgeddon
echo -e "${Blue}[*] Updating Airgeddon${ColorOff}"
git -C /opt/jexboss pull
chmod +x /opt/airgeddon/airgeddon.sh

# Cracking
# COOK
echo -e "${Blue}[*] Updating COOK${ColorOff}"
go install github.com/glitchedgitz/cook/v2/cmd/cook@latest