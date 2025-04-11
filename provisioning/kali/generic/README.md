# Kali <!-- omit in toc -->

## Table of Content <!-- omit in toc -->

- [Usage](#usage)
- [What it does](#what-it-does)
  - [Preseed.cfg](#preseedcfg)
    - [Credentials](#credentials)
  - [PostSeed.sh](#postseedsh)
    - [Configuration](#configuration)
    - [Tools](#tools)
      - [General Purpose](#general-purpose)
      - [Web applications tools](#web-applications-tools)
      - [Infrastructure tools](#infrastructure-tools)
      - [Mobile Tools](#mobile-tools)
      - [WiFi tools](#wifi-tools)
      - [Cracking](#cracking)
- [Update](#update)

## Usage

This guide is focused in Kali Linux using VirtualBox

1. [Download](https://www.kali.org/get-kali/#kali-installer-images) Kali Linux.
2. Create a new Virtual Machine.
3. Configure the Hardware, I recommend a minimum of 4096 MB of RAM, 3 CPUs processors and 100 GB of Hard Drive (it can be higher, depending on your hardware).
4. Before booting the VM, change the display setting to use at least 32 MB of Video memory in order to be able to rescale on bigger screen and with higher resolutions.
5. Boot the VirtualMachine.
6. Once booted go to Install and press the `Tab` key instead of the `Enter`, this will show a command line at the bottom, as shown in the next picture.

<center> <img id="Imagen-1" src="photos/Install-Kali.png" alt="Installer image" width="70%"> </center>

7. Once the command line is shown add the following changing the language, country, locale and keymap if needed. If you are not able to copy and paste, you can use any [Pastebin Services](https://github.com/lorien/awesome-pastebins) to copy and paste the content of the preseed.cfg file and type a shorter url instead of the one from Github. Also, you can use [ClickPaste](https://github.com/Collective-Software/ClickPaste) to paste into the Virtual Machine.

```shell
url=https://raw.githubusercontent.com/J0nan/RandomThings/refs/heads/main/provisioning/kali/generic/preseed.cfg language=en country=ES locale=en_US.UTF-8 keymap=es hostname=kali domain=
```

<center> <img id="Imagen-2" src="photos/Install-Kali-With-Command.png" alt="Installer image 2" width="70%"> </center>

8. After entering the command press `Enter` and wait until Kali is installed.

Sometimes for some reason, the cursor glitches out, if that happens just restart lightdm with:

```bash
sudo systemctl restart lightdm
```

## What it does

### Preseed.cfg

#### Credentials

User: `kali`
Password: `kali`

### PostSeed.sh

This script is executed by the installer after performing all the configurations and updating all the packages already install on the OS. The script does some [configuration](#configuration) and install some useful [tools](#tools).

#### Configuration

- Removes the transparency of the terminal.
- Disables power safe, blank screen and switch-off in the monitor

#### Tools

##### General Purpose

- python3 & python3-venv
- git
- golang-go
- docker (The services are disabled, use this to start them `systemctl start docker.service; systemctl start docker.socket`)
- snapd
- [SecList](https://github.com/danielmiessler/SecLists)
- dnsutils
- [DBeaver](https://dbeaver.io/)

##### Web applications tools

- [Nuclei](https://github.com/projectdiscovery/nuclei)
- [Interactsh](https://github.com/projectdiscovery/interactsh)
- [Testssl.sh](https://github.com/drwetter/testssl.sh)
- [wafw00f](https://github.com/EnableSecurity/wafw00f)
- [httpx](https://github.com/projectdiscovery/httpx)
- dirb
- gobuster
- [AMASS](https://github.com/owasp-amass/amass)
- [Subfinder](https://github.com/projectdiscovery/subfinder)
- arjun
- ffuf
- [Bypass-403](https://github.com/iamj0ker/bypass-403)
- [Corsy](https://github.com/s0md3v/Corsy)
- eyewitness

##### Infrastructure tools

- [Onesixtyone](https://github.com/trailofbits/onesixtyone)
- dnsrecon
- [Domain Analyzer](https://github.com/eldraco/domain_analyzer)
- dnsmasq
- [ssh-audit](https://github.com/jtesta/ssh-audit)
- [Terrapin-Scanner](https://github.com/RUB-NDS/Terrapin-Scanner)
- [JexBoss](https://github.com/joaomatosf/jexboss)
- sslscan

##### Mobile Tools

- jadx
- google-android-platform-tools-installer

##### WiFi tools

- [Airgeddon](https://github.com/v1s1t0r1sh3r3/airgeddon)

##### Cracking

- [COOK](https://github.com/glitchedgitz/cook)

## Update

Work in progress...
