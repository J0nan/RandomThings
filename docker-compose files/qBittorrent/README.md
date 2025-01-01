# qBittorrent + VPN docker compose

This docker compose implements [docker-qbittorrent](https://github.com/linuxserver/docker-qbittorrent) with [gluetun](https://github.com/qdm12/gluetun). It aims to use qBittorent with a VPN using OpenVPN.

## Usage

Modify every line of the [docker-compose.yml](./docker-compose.yml) file that has `# CHANGE ME` with the corresponding values.

As a summary and checklist the following fields highlighted must be changed:

- [ ] VPN_SERVICE_PROVIDER=`PROVIDER`
- [ ] OPENVPN_USER=`OPENVPN USER`
- [ ] OPENVPN_PASSWORD=`OPENVPN PASSWORD`
- [ ] SERVER_REGIONS=`SERVER REGION OR LIST OF SERVER REGIONS`
- [ ] `/mnt/QBITTORRENT_DIR`:/config
- [ ] `/mnt/MEDIA_DIR`:/download

For information regarding specific VPN providers go to the gluetun wiki: <https://github.com/qdm12/gluetun-wiki/tree/main/setup/providers>