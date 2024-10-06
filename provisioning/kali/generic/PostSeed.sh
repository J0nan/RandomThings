#!/bin/bash
# Author: J0nan
# Installs and configures multiple hacking tools
# It requieres:
#     - Go
#     - Python 3.12
#     - python3.12-venv

# Testssl.sh - https://github.com/drwetter/testssl.sh
sudo git clone https://github.com/drwetter/testssl.sh.git /opt/testssl.sh
sudo ln -s /opt/testssl.sh/testssl.sh /usr/bin/testssl

# Aquatone - https://github.com/firefart/aquatone
sudo git clone https://github.com/firefart/aquatone.git /opt/aquatone
cd /opt/aquatone
sudo go build /opt/aquatone
sudo ln -s /opt/aquatone/aquatone /usr/bin/aquatone

# ssh-audit - https://github.com/jtesta/ssh-audit
sudo git clone https://github.com/jtesta/ssh-audit.git /opt/ssh-audit
sudo ln -s /opt/ssh-audit/ssh-audit.py /usr/bin/ssh-audit

# Terrapin-Scanner - https://github.com/RUB-NDS/Terrapin-Scanner
sudo git clone https://github.com/RUB-NDS/Terrapin-Scanner.git /opt/Terrapin-Scanner
cd /opt/Terrapin-Scanner
sudo go build /opt/Terrapin-Scanner
sudo ln -s /opt/Terrapin-Scanner/Terrapin-Scanner /usr/bin/Terrapin-Scanner

# JexBoss - https://github.com/joaomatosf/jexboss
sudo git clone https://github.com/joaomatosf/jexboss.git /opt/jexboss
cd /opt/jexboss
sudo python3 -m venv /opt/jexboss
sudo /opt/jexboss/bin/python /opt/jexboss/bin/pip install -r requires.txt
sudo ln -s /opt/Terrapin-Scanner/Terrapin-Scanner /usr/bin/Terrapin-Scanner
sudo ln -s /opt/jexboss/jexboss.py /usr/bin/jexboss
