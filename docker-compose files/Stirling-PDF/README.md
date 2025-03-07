# Stirling-PDF docker compose

This docker compose implements [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF).

## Usage

Modify every line of the [docker-compose.yml](./docker-compose.yml) file that has `# CHANGE ME` with the corresponding values.

As a summary and checklist the following fields highlighted must be changed:

- [ ] `/mnt/STIRLINGPDF_DIR/trainingData`:/usr/share/tessdata/
- [ ] `/mnt/STIRLINGPDF_DIR/extraConfigs`:/configs/
- [ ] `/mnt/STIRLINGPDF_DIR/logs`:/logs/
