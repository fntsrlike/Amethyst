#!/bin/bash
source ./lib/bukkit-restrict.sh
source ./lib/common.sh
source ./lib/functions.sh

broadcast "伺服器將於 5 分鐘後重啟。"

countdown "5分鐘" 120
countdown "3分鐘" 120
countdown "1分鐘" 30
countdown "30秒" 20
countdown "10秒" 5
countdown "5秒" 1
countdown "4秒" 1
countdown "3秒" 1
countdown "2秒" 1
countdown "1秒" 1

broadcast "伺服器即將重啟。"
say "重啟預計需耗時 3 分鐘，建議可以先起身活動筋骨後，再嘗試登入。 =)"
sleep 3

execute "stop"
sleep 120

screen -wipe
sleep 1

./start.sh
