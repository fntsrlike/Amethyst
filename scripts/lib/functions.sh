source ./lib/common.sh

execute()
{
    COMMAND=$1
    screen -S $SOCK_NAME -p 0 -X stuff "$COMMAND
" # 作為 Enter 用，請不要併回上一行
}

say()
{
    ANOUNCEMENT_STRING=$1
    execute "minecraft:say $ANOUNCEMENT_STRING"
}

broadcast()
{
    ANOUNCEMENT_STRING=$1
    execute "say $ANOUNCEMENT_STRING"
}

countdown()
{
    REMAIN_TIME=$1
    SLEEP_SECOND=$2
    IS_BROADCAST=$3
    MESSAGE="本伺服器即將於${REMAIN_TIME}後關閉。"

    if [ "$IS_BROADCAST" == "true" ]; then
        broadcast $MESSAGE
    else
        say $MESSAGE
    fi

    sleep $SLEEP_SECOND
}
