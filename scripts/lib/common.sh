PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

SERVER_DIR="$(dirname "$PWD")"
SERVER_NAME=${SERVER_DIR##*/}
SOCK_NAME="MCServer${SERVER_NAME}"

PLUGIN_DIR="${SERVER_DIR}/plugins"
CONFIG_DIR="${SERVER_DIR}/configs"
WORLD_DIR="${SERVER_DIR}/worlds"
BACKUP_ROOT_DIR="${SERVER_DIR}/_backup"

[ ! -d "${CONFIG_DIR}/vanilla" ] && mkdir -p "${CONFIG_DIR}/vanilla"
[ ! -d "${CONFIG_DIR}/spigot" ] && mkdir -p "${CONFIG_DIR}/spigot"
[ ! -d "${BACKUP_ROOT_DIR}/" ] && mkdir -p "${BACKUP_ROOT_DIR}/"
