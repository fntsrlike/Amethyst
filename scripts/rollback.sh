#!/bin/bash
source "./lib/common.sh"

cd $BAK_SNAPSHOT_DIR
SNAPSHOT_DIR="${BAK_SNAPSHOT_DIR}/$(ls -1 | sort -r | head -n 1)"

BACKUP_DIR="${BAK_B4_ROLLBACK_DIR}/$(date +"%Y-%m-%d_%H.%M.%S")"
[ ! -d "${BACKUP_DIR}/" ] && mkdir -p "${BACKUP_DIR}/"


cd $SERVER_DIR
echo "Backup before rollback.."
echo "src: $SERVER_DIR"
echo "dest: $BACKUP_DIR"
rsync -avzHP -f "merge $CONFIGS_DIR/backup-plugins.rsync" ./ $BACKUP_DIR

cd $SNAPSHOT_DIR
echo "Begin rollback.."
echo "src: $SNAPSHOT_DIR"
echo "dest: $SERVER_DIR"
rsync -avzHPI -f "merge $CONFIGS_DIR/backup-plugins.rsync" ./ $SERVER_DIR
