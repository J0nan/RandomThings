# DeezSpot_bot_docker docker compose

This docker compose implements [DeezSpot_bot_docker](https://github.com/J0nan/DeezSpot_bot_docker).

## Usage

Modify every line of the [docker-compose.yml](./docker-compose.yml) file that has `# CHANGE ME` with the corresponding values.

As a summary and checklist the following fields highlighted must be changed:

- [ ] USER_ERRORS=`CHAT_ID_ERRORS`
- [ ] BUNKER_CHANNEL=`BUNKER_CHANNEL_ID`
- [ ] OWL_CHANNEL=`OWL_CHANNEL_ID`
- [ ] ROOT_ID=`ROOT_USER_ID`
- [ ] BOT_NAME="`"BOT_NAME`"
- [ ] ARL_TOKEN=`DEEZER_ARL_TOKEN`
- [ ] EMAIL_DEE=`DEEZER_EMAIL`
- [ ] PWD_DEE=`DEEZER_PASSWORD`
- [ ] EMAIL_SPO=`SPOTIFY_EMAIL`
- [ ] PWD_SPO=`SPOTIFY_PASSWORD`
- [ ] BOT_TOKEN=`TELEGRAM_BOT_TOKEN`
- [ ] API_ID=`TELEGRAM_API_ID`
- [ ] API_HASH=`TELEGRAM_API_HASH`
- [ ] /mnt/`DB_DIR`:/app/DB
- [ ] /mnt/`LOGS_DIR`:/app/logs

For information regarding how to get some tokens, credentials or options check the repository: <https://github.com/J0nan/DeezSpot_bot_docker?tab=readme-ov-file#where-to-get-some-tokens>
