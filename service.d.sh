. /data/adb/modules/mihomo/config.sh || exit 1
exec >"$LOG_DIR/service.d.log" 2>&1


echo "$(log_info): - 等待系统启动完成..."
while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 2; done
echo "$(log_info): - 系统启动完成, 等待/data分区解密完成..."
while [ "$(getprop sys.user.0.ce_available)" != "true" ] && [ "$(getprop sys.user.0.ce_available)" != "1" ]; do sleep 2; done
echo "$(log_info): - /data分区解密完成, 开始启动服务...\n"

if [ -f "$MODULES_DIR/disable" ] ; then
    echo "$(log_warning): - 模块已禁用, 不启动Mihomo!"
else
    start_mihomo
fi

start_inotifyd