#!/bin/bash
source ./lib/bukkit-restrict.sh
source ./lib/common.sh

cd "${CONFIG_DIR}/vanilla"

java \
    -Xms2G \
    -Xmx6G \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+UseZGC \
    -XX:+ZProactive \
    -XX:ZCollectionInterval=600 \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:+ParallelRefProcEnabled \
    -XX:+PerfDisableSharedMem \
    -Dlog4j.configurationFile="${CONFIG_DIR}/log4j2.xml" \
    -server \
    -jar "${SERVER_DIR}/server.jar" \
    --plugins $PLUGIN_DIR \
    --world-dir $WORLD_DIR \
    --bukkit-settings "${CONFIG_DIR}/spigot/bukkit.yml" \
    --spigot-settings "${CONFIG_DIR}/spigot/spigot.yml" \
    --commands-settings "${CONFIG_DIR}/spigot/commands.yml" \
    --nogui
