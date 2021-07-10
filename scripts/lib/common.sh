PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

MC_DIR=$(cd ../../..; printf %s "$PWD")
SERVER_DIR="$(dirname "$PWD")"

SERVER_NAME=${SERVER_DIR##*/}
SOCKET_NAME="MCServer${SERVER_NAME}"

PLUGINS_DIR="${SERVER_DIR}/plugins"
CONFIGS_DIR="${SERVER_DIR}/configs"
WORLDS_DIR="${SERVER_DIR}/worlds"

BAK_DIR="${MC_DIR}/backup/${SERVER_NAME}"
BAK_SNAPSHOT_DIR="${BAK_DIR}/snapshots"
BAK_B4_ROLLBACK_DIR="${BAK_DIR}/before_rollback"
BAK_B4_SYNC_DIR="${BAK_DIR}/before_sync"

[ ! -d "${CONFIGS_DIR}/vanilla" ] && mkdir -p "${CONFIGS_DIR}/vanilla/"
[ ! -d "${CONFIGS_DIR}/spigot" ] && mkdir -p "${CONFIGS_DIR}/spigot/"
[ ! -d "${BAK_DIR}/" ] && mkdir -p "${BAK_DIR}/"
[ ! -d "${BAK_SNAPSHOT_DIR}/" ] && mkdir -p "${BAK_SNAPSHOT_DIR}/"
[ ! -d "${BAK_B4_ROLLBACK_DIR}/" ] && mkdir -p "${BAK_B4_ROLLBACK_DIR}/"
[ ! -d "${BAK_B4_SYNC_DIR}/" ] && mkdir -p "${BAK_B4_SYNC_DIR}/"
