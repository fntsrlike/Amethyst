#!/bin/bash
source "./lib/common.sh"

cd "${CONFIG_DIR}/vanilla"

java \
    -Dlog4j.configurationFile="${CONFIG_DIR}/log4j2.xml" \
    -server \
    -jar "${SERVER_DIR}/server.jar" \
    --plugins $PLUGIN_DIR \
    --world-dir $WORLD_DIR \
    --bukkit-settings "${CONFIG_DIR}/spigot/bukkit.yml" \
    --spigot-settings "${CONFIG_DIR}/spigot/spigot.yml" \
    --commands-settings "${CONFIG_DIR}/spigot/commands.yml" \
    --nogui
