#!/bin/bash
# Author: J0nan
# Installs and configures multiple hacking tools

# Install requiered packages
apt install -y python3.12-venv
apt install -y golang-go
apt install -y docker.io
apt install -y google-android-platform-tools-installer

# Testssl.sh - https://github.com/drwetter/testssl.sh
git clone https://github.com/drwetter/testssl.sh.git /opt/testssl.sh
ln -s /opt/testssl.sh/testssl.sh /usr/bin/testssl

# Aquatone - https://github.com/firefart/aquatone
git clone https://github.com/firefart/aquatone.git /opt/aquatone
cd /opt/aquatone
go build /opt/aquatone
ln -s /opt/aquatone/aquatone /usr/bin/aquatone

# ssh-audit - https://github.com/jtesta/ssh-audit
git clone https://github.com/jtesta/ssh-audit.git /opt/ssh-audit
ln -s /opt/ssh-audit/ssh-audit.py /usr/bin/ssh-audit

# Terrapin-Scanner - https://github.com/RUB-NDS/Terrapin-Scanner
git clone https://github.com/RUB-NDS/Terrapin-Scanner.git /opt/Terrapin-Scanner
cd /opt/Terrapin-Scanner
go build /opt/Terrapin-Scanner
ln -s /opt/Terrapin-Scanner/Terrapin-Scanner /usr/bin/Terrapin-Scanner

# JexBoss - https://github.com/joaomatosf/jexboss
git clone https://github.com/joaomatosf/jexboss.git /opt/jexboss
cd /opt/jexboss
python3 -m venv /opt/jexboss
/opt/jexboss/bin/python /opt/jexboss/bin/pip install -r requires.txt
ln -s /opt/jexboss/jexboss.py /usr/bin/jexboss
