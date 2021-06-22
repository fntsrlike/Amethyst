#!/bin/bash
source ./lib/bukkit-restrict.sh
source ./lib/functions.sh

sleep 3
broadcast "本伺服器將進行關機維護。"
sleep 3
broadcast "重啟時間可以等候Discord上的通知、或關注本伺服器的粉絲專頁。 = )"
sleep 3

countdown "1分鐘" 30 true
countdown "30秒" 20
countdown "10秒" 5
countdown "5秒" 1
countdown "4秒" 1
countdown "3秒" 1
countdown "2秒" 1
countdown "1秒" 1

broadcast "伺服器即將關閉。"
sleep 3

execute "stop"
sleep 3

screen -wipe
sleep 3
