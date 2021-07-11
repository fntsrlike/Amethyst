#!/bin/bash
source "./lib/common.sh"

PROD_DIR_RELATIVE=".env/production"
PROD_DIR_ABSOLUTE="${SERVER_DIR}/${PROD_DIR_RELATIVE}"
[ ! -d "${PROD_DIR_ABSOLUTE}/" ] && echo "Directory ${PROD_DIR_RELATIVE} is not exist!" && exit

BACKUP_DIR="${BACKUP_BSC_DIR}/$(date +"%Y-%m-%d_%H.%M.%S")"
[ ! -d "${BACKUP_DIR}/" ] && mkdir -p "${BACKUP_DIR}/"

cd $SERVER_DIR

echo "Backup before sync.."
echo "src: $SERVER_DIR"
echo "dest: $BACKUP_DIR"
rsync -avzHP -f "merge $CONFIGS_DIR/configs/sync-from-prod.rsync" ./ $BACKUP_DIR

cd $PROD_DIR_ABSOLUTE
echo "Begin sync.."
echo "src: $PROD_DIR_ABSOLUTE"
echo "dest: $SERVER_DIR"
rsync -avzHPIL -f "merge $CONFIGS_DIR/configs/sync-from-prod.rsync" ./ $SERVER_DIR
