#!/bin/bash
source "./lib/common.sh"

BACKUP_DATE_DIR=${BACKUP_ROOT_DIR}/$(date +"%Y-%m-%d_%H.%M.%S")
[ ! -d "${BACKUP_DATE_DIR}/" ] && mkdir -p "${BACKUP_DATE_DIR}/"

cd $SERVER_DIR

echo "src: $SERVER_DIR"
echo "dest: $BACKUP_DATE_DIR"

rsync -avzHP -f "merge $SERVER_DIR/configs/backup-plugins.rsync" ./ $BACKUP_DATE_DIR
# rsync -avzHP -f "merge ${CONFIG_DIR}/backup-plugins.rsync" ../ $BACKUP_DATE_DIR

# -v, --verbose               increase verbosity
# -z, --compress              compress file data during the transfer
#     --compress-level=NUM    explicitly set compression level
# -H, --hard-links            preserve hard links

# -a, --archive               archive mode; same as -rlptgoD (no -H)
# -r, --recursive             recurse into directories
# -l, --links                 copy symlinks as symlinks
# -p, --perms                 preserve permissions
# -t, --times                 preserve times
# -g, --group                 preserve group
# -o, --owner                 preserve owner (super-user only)
# -D                          same as --devices --specials
#     --devices               preserve device files (super-user only)
#     --specials              preserve special files

# -P                          same as --partial --progress
#     --progress              show progress during transfer
#     --partial               keep partially transferred files
