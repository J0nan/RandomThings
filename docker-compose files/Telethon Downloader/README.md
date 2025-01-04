# Telethon Downloader docker compose

This docker compose implements [Telethon Downloader](https://github.com/jsavargas/telethon_downloader).

## Usage

Modify every line of the [docker-compose.yml](./docker-compose.yml) file that has `# CHANGE ME` with the corresponding values.

As a summary and checklist the following fields highlighted must be changed:

- [ ] TG_AUTHORIZED_USER_ID:`USER_CHAT_ID`
- [ ] TG_API_ID:`TELEGRAM_API_ID`
- [ ] TG_API_HASH:`TELEGRAM_API_HASH`
- [ ] TG_BOT_TOKEN:`TELEGRAM_BOT_TOKEN`
- [ ] /mnt/`TELETHON_CONFIG`:/config
- [ ] /mnt/`TELETHON_DOWNLOAD`:/download

For information regarding how to get some tokens, credentials or options check the repository: <https://github.com/jsavargas/telethon_downloader>
