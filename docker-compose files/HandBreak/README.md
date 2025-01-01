# HandBreak docker compose

This docker compose implements [docker-handbrake](https://github.com/jlesage/docker-handbrake).

## Usage

Modify every line of the [docker-compose.yml](./docker-compose.yml) file that has `# CHANGE ME` with the corresponding values.

As a summary and checklist the following fields highlighted must be changed:

- [ ] VNC_PASSWORD=`password`
- [ ] `/mnt/HANDBREAK_DIR`:/config
- [ ] `/mnt/MEDIA_DIR`:/storage:ro
- [ ] `/mnt/HANDBREAK_OUT`:/output
