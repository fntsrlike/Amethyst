#!/bin/bash
source ./lib/bukkit-restrict.sh
source ./lib/common.sh

screen -dmS "${SOCK_NAME}" ./server.sh
