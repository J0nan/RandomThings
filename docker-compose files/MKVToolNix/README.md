# MKVToolNix docker compose

This docker compose implements [docker-mkvtoolnix](https://github.com/jlesage/docker-mkvtoolnix).

## Usage

Modify every line of the [docker-compose.yml](./docker-compose.yml) file that has `# CHANGE ME` with the corresponding values.

As a summary and checklist the following fields highlighted must be changed:

- [ ] VNC_PASSWORD=`password`
- [ ] `/mnt/MKVTOOLNIX_DIR`:/config
- [ ] `/mnt/MKVTOOLNIX_OUT`:/output
