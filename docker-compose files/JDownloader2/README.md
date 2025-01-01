# JDownloader 2 + VPN docker compose

This docker compose implements [docker-jdownloader-2](https://github.com/jlesage/docker-jdownloader-2) with [gluetun](https://github.com/qdm12/gluetun). It aims to use JDownloader 2 with a VPN using OpenVPN.

## Usage

Modify every line of the [docker-compose.yml](./docker-compose.yml) file that has `# CHANGE ME` with the corresponding values.

As a summary and checklist the following fields highlighted must be changed:

- [ ] VPN_SERVICE_PROVIDER=`PROVIDER`
- [ ] OPENVPN_USER=`OPENVPN USER`
- [ ] OPENVPN_PASSWORD=`OPENVPN PASSWORD`
- [ ] SERVER_REGIONS=`SERVER REGION OR LIST OF SERVER REGIONS`
- [ ] VNC_PASSWORD=`password`
- [ ] `/mnt/JDOWNLOADER2_DIR`:/config
- [ ] `/mnt/MEDIA_DIR`:/output

For information regarding specific VPN providers go to the gluetun wiki: <https://github.com/qdm12/gluetun-wiki/tree/main/setup/providers>