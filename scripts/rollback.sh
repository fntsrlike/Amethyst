#!/bin/bash
source "./lib/common.sh"

BACKUP_DATE_DIR=${BACKUP_ROOT_DIR}/_before_rollback_$(date +"%Y-%m-%d_%H.%M.%S")
[ ! -d "${BACKUP_DATE_DIR}/" ] && mkdir -p "${BACKUP_DATE_DIR}/"

cd $SERVER_DIR

echo "Backup before rollback.."
echo "src: $SERVER_DIR"
echo "dest: $BACKUP_DATE_DIR"
rsync -avzHP -f "merge $SERVER_DIR/configs/backup-plugins.rsync" ./ $BACKUP_DATE_DIR


cd $BACKUP_ROOT_DIR
BACKUP_LASTEST_DIR="${BACKUP_ROOT_DIR}/$(ls -1 | sort -r | head -n 1)"

cd $BACKUP_LASTEST_DIR
echo "Begin rollback.."
echo "src: $BACKUP_LASTEST_DIR"
echo "dest: $SERVER_DIR"
rsync -avzHPI -f "merge $SERVER_DIR/configs/backup-plugins.rsync" ./ $SERVER_DIR
