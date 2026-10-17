. /data/adb/modules/mihomo/config.sh || exit 1
exec >>"$LOG_DIR/inotifyd.log" 2>&1

case "$1" in
    n)
        if [ "$2/$3" = "$MODULES_DIR/disable" ]; then
            echo "$(log_info): - 模块已禁用, 启动热重载流程......"
            stop_mihomo
            echo "$(log_info): - 热重载流程结束! \n"
        fi
    ;;
    d)
        if [ "$2/$3" = "$MODULES_DIR/disable" ]; then
            echo "$(log_info): - 模块已启用, 启动热重载流程......"
            start_mihomo
            echo "$(log_info): - 热重载流程结束! \n"
        fi
    ;;
    0)
        if [ "$2/$3" = "$MODULES_DIR/bin/mihomo" ]; then
            [ -f "$MODULES_DIR/disable" ] || {
                sleep 5
                [ -z "$(mihomo_pid)" ] && {
                    echo "$(log_info): - Mihomo核心被意外停止, 启动热重载流程......"
                    start_mihomo
                    echo "$(log_info): - 热重载流程结束! \n"
                }
            }
        fi
    ;;
esac