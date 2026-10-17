#!/system/bin/sh

export NULL='/dev/null'
export TZ=Asia/Shanghai

export MODULES_DIR="/data/adb/modules/mihomo"
export PATH="/data/adb/ksu/bin:$MODULES_DIR/bin:$PATH"
export LOG_DIR="$MODULES_DIR/log" ; [ -d "$LOG_DIR" ] || mkdir -p "$LOG_DIR"


log_info() { echo "[ INFO $(date +'%m月%d日 %H时%M分%S秒') ]" ; }
log_warning() { echo "[ WARNING $(date +'%m月%d日 %H时%M分%S秒') ]" ; }
log_error() { echo "[ ERROR $(date +'%m月%d日 %H时%M分%S秒') ]" ; }


export MIHOMO_CONFIG_DIR="$MODULES_DIR/etc"
mihomo_pid() { pgrep -f 'mihomo -d' ; }
start_mihomo() {
    local pid="$(mihomo_pid)"
    echo "$(log_info): - 正在启动Mihomo......"
    [ -z "$pid" ] || {
        echo "$(log_error): - Mihomo正在后台运行, PID: $pid, 启动失败!"
        return 1
    }
    echo "$(log_info): - 开始测试Mihomo配置文件完整性......"
    if mihomo -t -d "$MIHOMO_CONFIG_DIR" >"$LOG_DIR/error_mihomo.log" 2>&1; then
        echo "$(log_info): - Mihomo配置文件完整性测试成功!"
    else
        echo "$(log_error): - Mihomo配置文件完整性测试失败, 启动失败!"
        return 1
    fi
    mihomo -d "$MIHOMO_CONFIG_DIR" >"$LOG_DIR/mihomo.log" &
    echo "$(log_info): - Mihomo启动成功, PID: $!"
}
stop_mihomo() {
    local pid="$(mihomo_pid)"
    echo "$(log_info): - 正在停止Mihomo......"
    [ -z "$pid" ] && {
        echo "$(log_error): - Mihomo未在后台运行, 停止失败!"
        return 1
    }
    for _pid in $pid ; do
        if kill "$_pid" 2>$NULL; then
            echo "$(log_info): - Mihomo停止成功, PID: $_pid"
        else
            echo "$(log_error): - Mihomo停止失败, PID: $_pid"
        fi
    done
    sleep 1
}

export INOTIFYD_EXEC_FILE="$MODULES_DIR/inotifyd.sh"
inotifyd_pid() { pgrep -f "inotifyd.*$INOTIFYD_EXEC_FILE" ; }
start_inotifyd() {
    local pid="$(inotifyd_pid)"
    echo "$(log_info): - 正在启动INOTIFYD......"
    if [ ! -z "$pid" ] ; then
        echo "$(log_error): - INOTIFYD正在后台运行, PID: $pid, 启动失败!"
        return 1
    fi
    inotifyd "$INOTIFYD_EXEC_FILE" "$MODULES_DIR":nd "$MODULES_DIR/bin":0 &
    echo "$(log_info): - INOTIFYD启动完成, PID $!"
}
stop_inotifyd() {
    local pid="$(inotifyd_pid)"
    echo "$(log_info): - 正在停止INOTIFYD......"
    [ -z "$pid" ] && {
        echo "$(log_error): - INOTIFYD未在后台运行, 停止失败!"
        return 1
    }
    for _pid in $pid ; do
        if kill $_pid 2>/dev/null ; then
            echo "$(log_info): - INOTIFYD停止成功, PID: $_pid"
        else
            echo "$(log_error): - INOTIFYD停止失败, PID: $_pid"
        fi
    done
    sleep 1
}