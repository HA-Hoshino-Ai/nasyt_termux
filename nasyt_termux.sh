#!/bin/bash
#由HA制作的naster脚本🤓
# NAS油条工具箱（Termux版本）
#赤石/BUG反馈群号:610699712
#naster Bug反馈：1079737421

#🤓变量部分------------------
time_date="2026/02/21"
version="2.0.66"
nasyt_dir="$HOME/.nasyt"
source $nasyt_dir/naster_config.conf >/dev/null 2>&1 ;
config="$HOME/.nasyt/naster_config.conf"

version_update() {
    new_version=$(curl -L -s "https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/version.txt") 
}

update_config() {
    local key="$1"
    local value="$2"
    local config="$config"
    local tmp_file="${config}.tmp"
    if [ ! -f "$config" ]; then
        echo "${key} = ${value}" > "$config"
        return
    fi
    > "$tmp_file"
    local found=false
    while IFS= read -r line; do
        if echo "$line" | grep -qE "^\s*${key}\s*="; then
            echo "${key} = ${value}" >> "$tmp_file"
            found=true
        else
            echo "$line" >> "$tmp_file"
        fi
    done < "$config"
    if [ "$found" = false ]; then
        echo "${key} = ${value}" >> "$tmp_file"
    fi
    mv "$tmp_file" "$config"
}

check_option(){
    if grep -q "auto_update = true" "$config"; then
        version_update
        if [[ "$version" != "$new_version" ]]; then
            gx_main
        fi
    elif grep -q "auto_update = false" "$config"; then
        echo -e "$green auto_update$color = $blue false $color"
    else
        auto_update
    fi
}

auto_update(){
    $habit --title "启用自动更新" --yesno "是否启用自动更新？（启用后检查更新将会失效）" 0 0
    if [ $? -eq 0 ]; then
        echo "auto_update = true" > "$config"
        clear
        echo -e "$(info)请重启脚本！"
        exit 0
    else
        echo "auto_update = false" > "$config"
    fi
}

auto_update_pkg(){
    $habit --title "启用自动更新包" --yesno "是否启用自动更新包？" 0 0
    if [ $? -eq 0 ]; then
        echo "auto_update_pkg = true" > "$config"
        clear
        echo -e "$(info)请重启脚本！"
        exit 0
    else
        echo "auto_update_pkg = false" > "$config"
    fi
}

check_option_pkg(){
    if grep -q "auto_update_pkg = true" "$config"; then
        pkg update && pkg upgrade -y
    elif grep -q "auto_update_pkg = false" "$config"; then
        echo -e "$green auto_update_pkg$color = $blue false $color"
    else
        auto_update_pkg
    fi
}

gx_show() {
    version_update
    if [[ "$new_version" == "$version" ]]; then
        echo -e "$green 当前版本已是最新🤓 $color"
        esc
    else
        echo -e "$red 有新版本可更新😋 $new_version $color"
        curl "https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/update.txt"
        echo ""
        br
        echo "是否更新到最新版本？"
        echo "1.更新至最新版本$new_version"
        echo "2.保留现在的版本$version"
        read -p "请选择：" update_choose
        case $update_choose in
            1)
                gx_main
                ;;
            2)
                esc
                ;;
            *)
                echo "$(fail)无效的输入！请重新进入！"
                sleep 1
                ;;
        esac
    fi
}

gx_main(){
    echo -e "$(info)正在下载脚本..."
    curl -L -s -o $HOME/.nasyt/naster https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/nasyt_termux.sh
    echo -e "$(info)给予naster权限..."
    chmod +x $HOME/.nasyt/*
    echo -e "$(info)检查脚本是否安装..."
    if command -v naster >/dev/null 2>&1 ; then
        echo -e "$(info)检测到脚本！"
        sleep 0.5
        echo -e "$(info)输入$pink naster $color以启动脚本！"
        exit 0
    else
        echo -e "$(warn)未检测到脚本！"
        sleep 0.5
        echo -e "$(info)正在从Gitcode下载脚本..."
        curl -L -s -o $HOME/.nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/321b5fc06699d1e9125f4197e6bd7a02c7b3914f/nasyt_termux.sh
        echo -e "$(info)给予naster权限..."
        chmod +x $HOME/.nasyt/*
        echo -e "$(info)检查脚本是否安装..."
        if command -v naster >/dev/null 2>&1 ; then
            echo -e "$(info)检测到脚本！"
            sleep 0.5
            echo -e "$(info)输入$pink naster $color以启动脚本！"
            exit 0
        else
            echo -e "$(warn)未检测到脚本！"
            sleep 0.5
            echo -e "$(info)正在从GitHub下载脚本..."
            curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/HA-Hoshino-Ai/nasyt_termux/master/nasyt_termux.sh
            echo -e "$(info)给予naster权限..."
            chmod +x $HOME/.nasyt/*
            echo -e "$(info)检查脚本是否安装..."
            if command -v naster >/dev/null 2>&1 ; then
                echo -e "$(info)检测到脚本！"
                sleep 0.5
                echo -e "$(info)输入$pink naster $color以启动脚本！"
                exit 0
            else
                echo -e "$(warn)未检测到脚本！"
                sleep 0.5
                echo -e "$(fail)无法下载脚本！请稍后重试！"
                exit 0
            fi
        fi 
    fi
}

#🤓函数部分------------------

#返回函数
esc() {
    echo -e "按$green回车键$color$blue返回$color,按$yellow Ctrl+C$color$red退出$color $*"
    read
}

#定义颜色函数
color_variable() {
    color='\033[0m'
    green='\033[0;32m'
    blue='\033[0;34m'
    red='\033[31m'
    yellow='\033[33m'
    grey='\e[37m'
    pink='\033[38;5;218m'
    cyan='\033[96m'
}

#分割线函数
br() {
    echo -e "\e[1;34m————————————————————————————————————————————————————————————\e[0m"
}

#检查安装函数
pkg_install() {
    pkg_install_app="$*" #读取要安装的软件包
    if command -v $pkg_install_app >/dev/null 2>&1; then
        echo -e "$green ◉ $pkg_install_app已经安装，跳过安装步骤。$color"
    else 
        echo "正在安装$pkg_install_app"
        pkg install -y $pkg_install_app >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "$gred $pkg_install_app 安装失败 $color"
        else
            echo -e "$green $pkg_install_app 安装成功 $color"
        fi
    fi
}

# 根据时间返回问候语
get_greeting() {
    local hour=$(date +"%H")
    case $hour in
        05|06|07|08|09|10|11)
            echo "🌅 早上好！欢迎使用Termux工具箱"
            ;;
        12|13|14|15|16|17|18)
            echo "☀️ 下午好！欢迎使用Termux工具箱"
            ;;
        *)
            echo "🌙 晚上好！欢迎使用Termux工具箱"
            ;;
    esac
}

habit_option(){
    if [ "$habit" = "dialog" ] || [ "$habit" = "whiptail" ]; then
        echo -e "已加载上次设置：$green$habit$color"
        return 0
    fi
    if grep -q "habit = whiptail" "$config"; then
        habit=whiptail
    elif grep -q "habit = dialog" "$config"; then
        habit=dialog
    else
        habit_fs
    fi
}

habit_fs(){
    while true
    do
        echo "请选择触控方式🤓："
        echo "1.dialog点击式"
        echo "2.whiptail选择式"
        read -p "请选择：" habit_xz
        case $habit_xz in
            1) 
                clear
                pkg_install dialog
                habit="dialog"
                update_config "habit" "dialog"
                break
                ;;
            2)
                clear
                pkg_install whiptail
                habit="whiptail"
                update_config "habit" "whiptail"
                break
                ;;
            *)
                echo "无效的输入！"
                sleep 1 
                clear
                ;;
        esac
    done
}

must_pkg_install() {
    sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list >/dev/null
    echo -e "$(info)正在检查必备软件包安装"
    pkg_install curl 
    pkg_install neofetch 
    pkg_install figlet 
    pkg_install wget 
    pkg_install git
    pkg_install python
    pkg_install uv
    clear
}

#介绍
shell_head() {
    br
    get_greeting
    echo "欢迎使用Termux版本的NAS油条工具箱！"
    echo -e "$pink$(figlet N A S T E R) $color"
    echo ">_ TERMUX VERSION >_"
    echo -e "$blue 这个脚本非常适合Termux新手使用，但是你要明白, $red 该项目不允许二次上传/盗用 $color （除nasyt之外）$red ！！！$color"
    echo -e "$red 再说一次！该项目不允许二次上传/盗用！！！ $color"
    read
}

menu_main() {
    clear
    version_update
    if [[ "$new_version" == "$version" ]]; then
        echo -e "$green 当前版本已是最新🤓 $color"
        br
    else
        echo -e "$red 有新版本更新，请更新！😋 $new_version $color"
    fi
    if command -v figlet >/dev/null 2>&1; then
        figlet N A S x H A
        warn_head
    fi
    br
    echo "1) 启动naster"
    echo "2) 更新naster"
    echo "3) 卸载naster"
    echo "4) 降级naster"
    echo "5) 随机acg图片"
    br
    echo -e "已加载上次设置：$green$habit$color"
    read -p ">>>" menu_1_xz
}

#主函数
main() {
    must_pkg_install
    shell_head
    clear
    habit_option
    check_option
    check_option_pkg
    if command -v $habit >/dev/null 2>&1; then
        while true
        do
            menu_main
            case $menu_1_xz in
                1)
                    echo 1
                    index_main
                    esc
                    ;;
                2)
                    echo 2
                    clear
                    gx_show
                    clear
                    ;;
                3)
                    echo 3
                    rm -r $HOME/.nasyt/naster               
                    echo -e "$(info)已完成删除，但是保留了.nasyt文件夹！"
                    exit 0
                    ;;
                4)
                    echo -e "$(info)正在检查已有版本..."
                    if command -v naster >/dev/null 2>&1; then
                    clear
                    echo "当前版本：$version"
                    fi
                    echo -e "$(info)选择你想要下载的版本"
                    echo "(1)2.0.64"
                    echo "(2)2.0.63"
                    echo "(3)2.0.62"
                    echo "(4)2.0.61"
                    echo "(5)2.0.6"
                    echo "(6)2.0.51"
                    echo "(7)2.0.5"
                    echo "(0)←返回"
                    read -p ">>>" downdate_xz
                    case $downdate_xz in
                        1)
                            echo -e "$(info)请稍候..."
                            rm -r $HOME/.nasyt/naster
                            echo -e "$(info)正在下载脚本..."
                            curl -L -s -o $HOME/.nasyt/naster https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.64.sh
                            echo -e "$(info)给予naster权限..."
                            chmod +x $HOME/.nasyt/*
                            echo -e "$(info)检查脚本是否安装..."
                            if command -v naster >/dev/null 2>&1 ; then
                                echo -e "$(info)检测到脚本！"
                                sleep 0.5
                                echo -e "$(info)输入$pink naster $color以启动脚本！"
                                exit 0
                            else
                                echo -e "$(info)正在从Gitcode下载脚本..."
                                curl -L -s -o $HOME/.nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.64.sh
                                echo -e "$(info)给予naster权限..."
                                chmod +x $HOME/.nasyt/*
                                echo -e "$(info)检查脚本是否安装..."
                                if command -v naster >/dev/null 2>&1 ; then
                                    echo -e "$(info)检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)输入$pink naster $color以启动脚本！"
                                    exit 0
                                else
                                    echo -e "$(warn)未检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)正在从GitHub下载脚本..."
                                    curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/HA-Hoshino-Ai/nasyt_termux/master/history/nasyt_termux2.0.64.sh
                                    echo -e "$(info)给予naster权限..."
                                    chmod +x $HOME/.nasyt/*
                                    echo -e "$(info)检查脚本是否安装..."
                                    if command -v naster >/dev/null 2>&1 ; then
                                        echo -e "$(info)检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(info)输入$pink naster $color以启动脚本！"
                                        exit 0
                                    else
                                        echo -e "$(warn)未检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(fail)无法下载脚本！请稍后重试！"
                                        exit 0
                                    fi
                                fi 
                            fi
                            ;;
                        2)
                            echo -e "$(info)请稍候..."
                            rm -r $HOME/.nasyt/naster
                            echo -e "$(info)正在下载脚本..."
                            curl -L -s -o $HOME/.nasyt/naster https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.63.sh
                            echo -e "$(info)给予naster权限..."
                            chmod +x $HOME/.nasyt/*
                            echo -e "$(info)检查脚本是否安装..."
                            if command -v naster >/dev/null 2>&1 ; then
                                echo -e "$(info)检测到脚本！"
                                sleep 0.5
                                echo -e "$(info)输入$pink naster $color以启动脚本！"
                                exit 0
                            else
                                echo -e "$(info)正在从Gitcode下载脚本..."
                                curl -L -s -o $HOME/.nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.63.sh
                                echo -e "$(info)给予naster权限..."
                                chmod +x $HOME/.nasyt/*
                                echo -e "$(info)检查脚本是否安装..."
                                if command -v naster >/dev/null 2>&1 ; then
                                    echo -e "$(info)检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)输入$pink naster $color以启动脚本！"
                                    exit 0
                                else
                                    echo -e "$(warn)未检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)正在从GitHub下载脚本..."
                                    curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/HA-Hoshino-Ai/nasyt_termux/master/history/nasyt_termux2.0.63.sh
                                    echo -e "$(info)给予naster权限..."
                                    chmod +x $HOME/.nasyt/*
                                    echo -e "$(info)检查脚本是否安装..."
                                    if command -v naster >/dev/null 2>&1 ; then
                                        echo -e "$(info)检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(info)输入$pink naster $color以启动脚本！"
                                        exit 0
                                    else
                                        echo -e "$(warn)未检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(fail)无法下载脚本！请稍后重试！"
                                        exit 0
                                    fi
                                fi 
                            fi
                            ;;
                        3)
                            echo -e "$(info)请稍候..."
                            rm -r $HOME/.nasyt/naster
                            echo -e "$(info)正在下载脚本..."
                            curl -L -s -o $HOME/.nasyt/naster https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.62.sh
                            echo -e "$(info)给予naster权限..."
                            chmod +x $HOME/.nasyt/*
                            echo -e "$(info)检查脚本是否安装..."
                            if command -v naster >/dev/null 2>&1 ; then
                                echo -e "$(info)检测到脚本！"
                                sleep 0.5
                                echo -e "$(info)输入$pink naster $color以启动脚本！"
                                exit 0
                            else
                                echo -e "$(info)正在从Gitcode下载脚本..."
                                curl -L -s -o $HOME/.nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.62.sh
                                echo -e "$(info)给予naster权限..."
                                chmod +x $HOME/.nasyt/*
                                echo -e "$(info)检查脚本是否安装..."
                                if command -v naster >/dev/null 2>&1 ; then
                                    echo -e "$(info)检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)输入$pink naster $color以启动脚本！"
                                    exit 0
                                else
                                    echo -e "$(warn)未检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)正在从GitHub下载脚本..."
                                    curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/HA-Hoshino-Ai/nasyt_termux/master/history/nasyt_termux2.0.62.sh
                                    echo -e "$(info)给予naster权限..."
                                    chmod +x $HOME/.nasyt/*
                                    echo -e "$(info)检查脚本是否安装..."
                                    if command -v naster >/dev/null 2>&1 ; then
                                        echo -e "$(info)检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(info)输入$pink naster $color以启动脚本！"
                                        exit 0
                                    else
                                        echo -e "$(warn)未检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(fail)无法下载脚本！请稍后重试！"
                                        exit 0
                                    fi
                                fi 
                            fi
                            ;;
                        4)
                            echo -e "$(info)请稍候..."
                            rm -r $HOME/.nasyt/naster
                            echo -e "$(info)正在下载脚本..."
                            curl -L -s -o $HOME/.nasyt/naster https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.61.sh
                            echo -e "$(info)给予naster权限..."
                            chmod +x $HOME/.nasyt/*
                            echo -e "$(info)检查脚本是否安装..."
                            if command -v naster >/dev/null 2>&1 ; then
                                echo -e "$(info)检测到脚本！"
                                sleep 0.5
                                echo -e "$(info)输入$pink naster $color以启动脚本！"
                                exit 0
                            else
                                echo -e "$(info)正在从Gitcode下载脚本..."
                                curl -L -s -o $HOME/.nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.61.sh
                                echo -e "$(info)给予naster权限..."
                                chmod +x $HOME/.nasyt/*
                                echo -e "$(info)检查脚本是否安装..."
                                if command -v naster >/dev/null 2>&1 ; then
                                    echo -e "$(info)检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)输入$pink naster $color以启动脚本！"
                                    exit 0
                                else
                                    echo -e "$(warn)未检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)正在从GitHub下载脚本..."
                                    curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/HA-Hoshino-Ai/nasyt_termux/master/history/nasyt_termux2.0.61.sh
                                    echo -e "$(info)给予naster权限..."
                                    chmod +x $HOME/.nasyt/*
                                    echo -e "$(info)检查脚本是否安装..."
                                    if command -v naster >/dev/null 2>&1 ; then
                                        echo -e "$(info)检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(info)输入$pink naster $color以启动脚本！"
                                        exit 0
                                    else
                                        echo -e "$(warn)未检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(fail)无法下载脚本！请稍后重试！"
                                        exit 0
                                    fi
                                fi 
                            fi
                            ;;
                        5)
                            echo -e "$(info)请稍候..."
                            rm -r $HOME/.nasyt/naster
                            echo -e "$(info)正在下载脚本..."
                            curl -L -s -o $HOME/.nasyt/naster https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.6.sh
                            echo -e "$(info)给予naster权限..."
                            chmod +x $HOME/.nasyt/*
                            echo -e "$(info)检查脚本是否安装..."
                            if command -v naster >/dev/null 2>&1 ; then
                                echo -e "$(info)检测到脚本！"
                                sleep 0.5
                                echo -e "$(info)输入$pink naster $color以启动脚本！"
                                exit 0
                            else
                                echo -e "$(info)正在从Gitcode下载脚本..."
                                curl -L -s -o $HOME/.nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.6.sh
                                echo -e "$(info)给予naster权限..."
                                chmod +x $HOME/.nasyt/*
                                echo -e "$(info)检查脚本是否安装..."
                                if command -v naster >/dev/null 2>&1 ; then
                                    echo -e "$(info)检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)输入$pink naster $color以启动脚本！"
                                    exit 0
                                else
                                    echo -e "$(warn)未检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)正在从GitHub下载脚本..."
                                    curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/HA-Hoshino-Ai/nasyt_termux/master/history/nasyt_termux2.0.6.sh
                                    echo -e "$(info)给予naster权限..."
                                    chmod +x $HOME/.nasyt/*
                                    echo -e "$(info)检查脚本是否安装..."
                                    if command -v naster >/dev/null 2>&1 ; then
                                        echo -e "$(info)检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(info)输入$pink naster $color以启动脚本！"
                                        exit 0
                                    else
                                        echo -e "$(warn)未检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(fail)无法下载脚本！请稍后重试！"
                                        exit 0
                                    fi
                                fi 
                            fi
                            ;;
                        6)
                            echo -e "$(info)请稍候..."
                            rm -r $HOME/.nasyt/naster
                            echo -e "$(info)正在下载脚本..."
                            curl -L -s -o $HOME/.nasyt/naster https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.51.sh
                            echo -e "$(info)给予naster权限..."
                            chmod +x $HOME/.nasyt/*
                            echo -e "$(info)检查脚本是否安装..."
                            if command -v naster >/dev/null 2>&1 ; then
                                echo -e "$(info)检测到脚本！"
                                sleep 0.5
                                echo -e "$(info)输入$pink naster $color以启动脚本！"
                                exit 0
                            else
                                echo -e "$(info)正在从Gitcode下载脚本..."
                                curl -L -s -o $HOME/.nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.51.sh
                                echo -e "$(info)给予naster权限..."
                                chmod +x $HOME/.nasyt/*
                                echo -e "$(info)检查脚本是否安装..."
                                if command -v naster >/dev/null 2>&1 ; then
                                    echo -e "$(info)检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)输入$pink naster $color以启动脚本！"
                                    exit 0
                                else
                                    echo -e "$(warn)未检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)正在从GitHub下载脚本..."
                                    curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/HA-Hoshino-Ai/nasyt_termux/master/history/nasyt_termux2.0.51.sh
                                    echo -e "$(info)给予naster权限..."
                                    chmod +x $HOME/.nasyt/*
                                    echo -e "$(info)检查脚本是否安装..."
                                    if command -v naster >/dev/null 2>&1 ; then
                                        echo -e "$(info)检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(info)输入$pink naster $color以启动脚本！"
                                        exit 0
                                    else
                                        echo -e "$(warn)未检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(fail)无法下载脚本！请稍后重试！"
                                        exit 0
                                    fi
                                fi 
                            fi
                            ;;
                        7)
                            echo -e "$(info)请稍候..."
                            rm -r $HOME/.nasyt/naster
                            echo -e "$(info)正在下载脚本..."
                            curl -L -s -o $HOME/.nasyt/naster https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.5.sh
                            echo -e "$(info)给予naster权限..."
                            chmod +x $HOME/.nasyt/*
                            echo -e "$(info)检查脚本是否安装..."
                            if command -v naster >/dev/null 2>&1 ; then
                                echo -e "$(info)检测到脚本！"
                                sleep 0.5
                                echo -e "$(info)输入$pink naster $color以启动脚本！"
                                exit 0
                            else
                                echo -e "$(info)正在从Gitcode下载脚本..."
                                curl -L -s -o $HOME/.nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/master/history/nasyt_termux2.0.5.sh
                                echo -e "$(info)给予naster权限..."
                                chmod +x $HOME/.nasyt/*
                                echo -e "$(info)检查脚本是否安装..."
                                if command -v naster >/dev/null 2>&1 ; then
                                    echo -e "$(info)检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)输入$pink naster $color以启动脚本！"
                                    exit 0
                                else
                                    echo -e "$(warn)未检测到脚本！"
                                    sleep 0.5
                                    echo -e "$(info)正在从GitHub下载脚本..."
                                    curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/HA-Hoshino-Ai/nasyt_termux/master/history/nasyt_termux2.0.5.sh
                                    echo -e "$(info)给予naster权限..."
                                    chmod +x $HOME/.nasyt/*
                                    echo -e "$(info)检查脚本是否安装..."
                                    if command -v naster >/dev/null 2>&1 ; then
                                        echo -e "$(info)检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(info)输入$pink naster $color以启动脚本！"
                                        exit 0
                                    else
                                        echo -e "$(warn)未检测到脚本！"
                                        sleep 0.5
                                        echo -e "$(fail)无法下载脚本！请稍后重试！"
                                        exit 0
                                    fi
                                fi 
                            fi
                            ;;
                        0)
                            break
                            ;;
                    esac     
                    break
                    ;;
                5)
                    while true
                    do
                        clear
                        pkg_install chafa
                        acg_menu
                        case $acg_menu_xz in
                            1)
                                mkdir -p $save_place
                                total=1
                                clear
                                echo -e "$red注意：$color将终端缩小至合适比例已获取最佳效果!"
                                echo -e "$blue请在下方输入生成的张数$color（默认为1）"
                                read -p ">>>" user_need
                                while true
                                do
                                    if [[ "$total" == "$user_need" ]]; then
                                        echo -e "第$blue$total$color张"
                                        tp_curl=https://www.loliapi.com/acg/pe
                                        wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                        chafa $save_place/$time_name_xz.png
                                        echo -e "$(info) 图片已保存在$save_place/$time_name_xz.png"
                                        esc
                                        break
                                    else
                                        if [[ "$user_need" -lt "0" ]]; then
                                            echo -e "请输入$red大于0$color的数字！"
                                        fi
                                    fi
                                    if [[ "$total" -lt "$user_need" ]]; then
                                        echo -e "第$blue$total$color张"
                                        tp_curl=https://www.loliapi.com/acg/pe
                                        time_name_xz=()
                                        local tp_time=$(date +%Y%m%d_%H%M%S)
                                        local random=$(shuf -i 1000-9999 -n 1)
                                        local tp_pid_2=$(echo "_$tp_pid")
                                        local api_r18_2=$(echo "_$tp_r18")
                                        time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                        wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                        chafa $save_place/$time_name_xz.png
                                        total=$((total + 1))
                                    fi
                                    if [[ "$total" == "1" ]]; then
                                        echo -e "第$blue$total$color张"
                                        tp_curl=https://www.loliapi.com/acg/pe
                                        time_name_xz=()
                                        local tp_time=$(date +%Y%m%d_%H%M%S)
                                        local random=$(shuf -i 1000-9999 -n 1)
                                        local tp_pid_2=$(echo "_$tp_pid")
                                        local api_r18_2=$(echo "_$tp_r18")
                                        time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                        wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                        chafa $save_place/$time_name_xz.png
                                        echo -e "$(info) 图片已保存在$save_place/$time_name_xz.png"
                                        esc
                                        break
                                    fi
                                done
                                ;;
                            2)
                                mkdir -p $save_place/
                                total=1
                                clear
                                echo -e "$red注意：$color将终端缩小至合适比例已获取最佳效果!"
                                echo -e "$blue请在下方输入生成的张数$color（默认为1）"
                                read -p ">>>" user_need
                                while true
                                do
                                    if [[ "$total" == "$user_need" ]]; then
                                        echo -e "第$blue$total$color张"
                                        tp_curl=https://www.loliapi.com/acg/pc
                                        wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                        chafa $save_place/$time_name_xz.png
                                        echo -e "$(info) 图片已保存在$save_place/$time_name_xz.png"
                                        esc
                                        break
                                    else
                                        if [[ "$user_need" -lt "0" ]]; then
                                            echo -e "请输入$red大于0$color的数字！"
                                            read
                                            break
                                        fi
                                    fi
                                    if [[ "$total" -lt "$user_need" ]]; then
                                        echo -e "第$blue$total$color张"
                                        tp_curl=https://www.loliapi.com/acg/pc
                                        time_name_xz=()
                                        local tp_time=$(date +%Y%m%d_%H%M%S)
                                        local random=$(shuf -i 1000-9999 -n 1)
                                        local tp_pid_2=$(echo "_$tp_pid")
                                        local api_r18_2=$(echo "_$tp_r18")
                                        time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                        wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                        chafa $save_place/$time_name_xz.png
                                        total=$((total + 1))
                                    fi
                                    if [[ "$total" == "1" ]]; then
                                        echo -e "第$blue$total$color张"
                                        tp_curl=https://www.loliapi.com/acg/pe
                                        time_name_xz=()
                                        local tp_time=$(date +%Y%m%d_%H%M%S)
                                        local random=$(shuf -i 1000-9999 -n 1)
                                        local tp_pid_2=$(echo "_$tp_pid")
                                        local api_r18_2=$(echo "_$tp_r18")
                                        time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                        wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                        chafa $save_place/$time_name_xz.png
                                        echo -e "$(info) 图片已保存在$save_place/$time_name_xz.png"
                                        esc
                                        break
                                    fi
                                done
                                ;;
                            3)
                                echo "切换路径"
                                clear
                                save_place=$($habit --title "修改路径(末尾自动带\)" \
                                --inputbox "文字" 0 0 \
                                3>&1 1>&2 2>&3)
                                if [ "$save_place" == "" ]; then
                                    echo -e "$(warn)在修改路径时发生错误！"
                                    sleep 1
                                else
                                    if [ -e "$save_place" ]; then
                                        echo -e "$(info)路径存在,本次路径已修改为:$save_place"
                                    else
                                        echo -e "$(warn)路径不存在,请重新修改！已使用默认路径！"
                                        save_place=$HOME/.nasyt/acg
                                        sleep 1
                                    fi
                                fi
                                ;;
                            4)
                                break
                                ;;
                        esac
                        break
                    done
                    ;;
                0)
                    break
                    exit
                    ;;
                *)
                    echo "无效的输入"
                    sleep 1
                    clear
                    ;;
            esac
        done
    else
        echo "你未选择触控方式！"
        sleep 1
        habit_fs
        clear
    fi
}

warn_head(){
    echo -e "$red 注意！$color 请不要二次转发此项目！"
    echo -e "🤓脚本由$blue HA$color 和$blue NAS油条$color 制作"
}

#主页
main_home(){
    index_menu_xz=$($habit --title "NAS油条Linux工具箱" \
    --backtitle "版本:$version    更新时间:$time_date" \
    --menu "本工具箱由NAS油条xHA制作\nQQ群:610699712\n请使用方向键+回车键进行操作\n请选择你要启动的项目：" 0 0 10 \
    1 "系统工具" \
    2 "基础菜单" \
    3 "实验脚本" \
    4 "其他工具" \
    5 "其他脚本" \
    6 "随机美图" \
    7 "关于脚本" \
    8 "更新脚本" \
    9 "脚本设置" \
    0 "退出脚本" \
    3>&1 1>&2 2>&3) 
}

#系统工具
system_tools(){
    system_choice=$($habit --title "系统工具" \
    --menu "请选择" 0 0 10 \
    1 "查看本机信息" \
    2 "查看termux信息" \
    3 "查询IP信息" \
    0 "←返回" \
    3>&1 1>&2 2>&3)    
}

#基础脚本
basic_tools(){
    basic_choice=$($habit --title "基础菜单" \
    --menu "请选择" 0 0 10 \
    1 "机器人管理" \
    2 "容器管理" \
    3 "挂载工具" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#机器人管理
bot_mannage(){
    bot_mannage_xz=$($habit --title "机器人管理" \
    --menu "请选择" 0 0 10 \
    1 "机器人部署" \
    2 "机器人启动" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#机器人部署
bot_mannage_set(){
    bot_mannage_set_xz=$($habit --title "机器人部署" \
    --menu "请选择" 0 0 10 \
    1 "推荐部署方案AstrBot|NapCat🤓（基于容器）" \
    2 "安装AstrBot机器人" \
    3 "安装Napcat适配器" \
    4 "安装OneBot适配器" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#检查proot
astrbot_napcat(){
    clear
    echo "正在检查proot-distro状态"
    pkg_install proot-distro
    clear
}

#机器人启动
bot_mannage_start(){
    bot_mannage_start_xz=$($habit --title "机器人部署" \
    --menu "请选择" 0 0 10 \
    1 "启动AstrBot" \
    2 "启动NapCat" \
    3 "启动OneBot" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#容器管理
proot_manage(){
    proot_mannage_xz=$($habit --title "容器管理" \
    --menu "请选择" 0 0 10 \
    1 "下载容器" \
    2 "启动容器" \
    3 "卸载容器" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#容器下载
download_proot(){
    download_proot_xz=$($habit --title "容器下载" \
    --menu "请选择" 0 0 10 \
    1 "adelie" \
    2 "almalinux" \
    3 "alpine" \
    4 "archlinux" \
    5 "artix" \
    6 "chimera" \
    7 "debian" \
    8 "fedora" \
    9 "manjaro" \
    10 "opensuse" \
    11 "oracle" \
    12 "pardus" \
    13 "rockylinux" \
    14 "termux" \
    15 "trisquel" \
    16 "ubuntu " \
    17 "void" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#容器启动
start_dialog_proot(){
    INSTALL_DIR="/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs"
    if [ ! -d "$INSTALL_DIR" ]; then
        $habit --msgbox "未找到 proot-distro 安装目录: $INSTALL_DIR" 10 50
        exit 1
    fi
    containers=($(ls -1 "$INSTALL_DIR"))
    if [ ${#containers[@]} -eq 0 ]; then
        $habit --msgbox "没有找到任何已安装的容器。" 10 40
        break
    fi
    menu_options=()
    for container in "${containers[@]}"; do
        menu_options+=("$container" "")
    done
    selected=$($habit --title "已安装的容器" \
        --menu "请选择：" 15 50 8 \
        "${menu_options[@]}" \
        2>&1 >/dev/tty)
    clear
    if [ -n "$selected" ]; then
    proot-distro login "$selected"
    fi
}

#容器卸载
remove_dialog_proot(){
    INSTALL_DIR="/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs"
    if [ ! -d "$INSTALL_DIR" ]; then
        $habit --msgbox "未找到 proot-distro 安装目录: $INSTALL_DIR" 10 50
        exit 1
    fi
    containers=($(ls -1 "$INSTALL_DIR"))
    if [ ${#containers[@]} -eq 0 ]; then
        $habit --msgbox "没有找到任何已安装的容器。" 10 40
        exit 0
    fi
    menu_options=()
    for container in "${containers[@]}"; do
        menu_options+=("$container" "")
    done
    selected=$($habit --title "已安装的容器" \
        --menu "请选择:" 15 50 8 \
        "${menu_options[@]}" \
        2>&1 >/dev/tty)
    clear
    if [ -n "$selected" ]; then
    proot-distro remove "$selected"
    fi
}

#各种面板
baka(){
    baka_xz=$($habit --title "挂载工具" \
    --menu "请选择" 0 0 10 \
    1 "alist部署" \
    0 "←返回" \
    2>&1 1>/dev/tty)
}

#实验性脚本
test_shell(){
    test_shell_xz=$($habit --title "实验脚本" \
    --menu "请选择" 0 0 10 \
    1 "QEMU管理" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}
 
#QEMU管理
qemu_shell(){
qemu_shell_xz=$($habit --title "QEMU管理" \
    --menu "安装RVNCViewer应用，连接到127.0.0.1:5903（根据-vnc参数中的端口号调整），即可看到界面" 0 0 10 \
    1 "安装系统(QEMU)" \
    2 "启动系统(QEMU)" \
    3 "扩展.img内存" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#其他工具
other_shell(){
    other_shell_xz=$($habit --title "其他工具" \
    --menu "请选择" 0 0 10 \
    1 "Kali安装" \
    2 "ADB工具" \
    3 "音乐播放" \
    4 "PING检查" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#ADB未配对时
adb_tool_unpair(){
    adb_tool_xz=$($habit --title "ADB工具" \
    --menu "请选择" 0 0 10 \
    1 "配对设备" \
    6 "连接设备" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}
#ADB配对时
adb_tool_pair(){
    adb_tool_xz=$($habit --title "ADB工具" \
    --menu "请选择" 0 0 10 \
    1 "重新配对" \
    2 "激活Shizuku" \
    3 "激活Scene" \
    4 "激活AxManager" \
    5 "其他工具" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#ADB其他工具
adb_other_shell(){
    adb_other_shell_xz=$($habit --title "其他工具" \
    --menu "注意！请详细阅读本段文字！adb工具部分功能存在风险！请搜索相关功能后再使用！\n若出现损坏，本人不负责!" 0 0 10 \
    1 "ADB截图" \
    2 "重启设备" \
    3 "重启到Fastboot" \
    4 "重启到Recovery" \
    5 "重启到9008" \
    6 "输入adb指令" \
    0 "←返回" \
    2>&1 1>/dev/tty)
}

#其他脚本
other_script(){
    other_script_xz=$($habit --title "其他脚本" \
    --menu "请选择" 0 0 10 \
    1 "Mit_gancm MC服务器部署" \
    2 "naster前置脚本nasyt" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#音乐播放
music_player(){
    music_player_xz=$($habit --title "音乐播放" \
    --menu "请选择" 0 0 10 \
    1 "内部存储" \
    2 "脚本自带" \
    3 "ncm转换" \
    0 "←返回" \
    2>&1 1>/dev/tty)
}

# 搜索并选择MP3文件
search_and_play_mp3() {
    echo "正在搜索MP3文件，请稍候..."
    mp3_files=$(find $files_music -name "*.mp3" -type f 2>/dev/null | head -30)    
    if [ -z "$mp3_files" ]; then
        $habit --title "MP3文件搜索" \
        --msgbox "在$files_music中未找到MP3文件!" 0 0
        break
    fi
    file_count=$(echo "$mp3_files" | wc -l)
    options=()
    file_paths=()
    counter=1
    while IFS= read -r file; do
        if [ -n "$file" ]; then
            filename=$(basename "$file")
            filesize=$(du -h "$file" 2>/dev/null | cut -f1)
            if [ ${#filename} -gt 35 ]; then
                display_name="${filename:0:32}..."
            else
                display_name="$filename"
            fi
            display_name="$display_name ($filesize)"
            options+=("$counter" "$display_name")
            file_paths+=("$file")
            ((counter++))
        fi
    done <<< "$mp3_files"
    options+=(0 "←返回")
    while true
    do
        choice=$($habit --title "MP3文件列表 (共 $file_count 个文件)" \
        --menu "选择要播放的MP3文件：" 0 0 10 \
        "${options[@]}" \
        3>&1 1>&2 2>&3)
        if [ $? -ne 0 ] || [ "$choice" = "0" ]; then
            break
            break
        elif [ -n "$choice" ] && [ "$choice" -ge 1 ] && [ "$choice" -le $file_count ]; then
            selected_file="${file_paths[$((choice-1))]}"
                mpv "$selected_file"
        else
            $habit --title "错误" --msgbox "无效的选择" 8 40
        fi
    done
}

# NCM文件转换函数
ncm_converter() {
    echo "正在搜索NCM文件..."
    ncm_files=$(find "$localmusic_netease" -name "*.ncm" -type f 2>/dev/null | head -30)
    if [ -z "$ncm_files" ]; then
        $habit --title "提示" --msgbox "在指定目录中未找到NCM文件" 0 0
        return 1
    fi
    ncm_file_count=$(echo "$ncm_files" | wc -l)
    ncm_options=()
    ncm_file_paths=()
    ncm_counter=1
    while IFS= read -r ncm_file
    do
        if [ -n "$ncm_file" ]; then
            ncm_filename=$(basename "$ncm_file")
            ncm_filesize=$(du -h "$ncm_file" 2>/dev/null | cut -f1)
            if [ ${#ncm_filename} -gt 35 ]; then
                ncm_display_name="${ncm_filename:0:32}..."
            else
                ncm_display_name="$ncm_filename"
            fi
            ncm_display_name="$ncm_display_name ($ncm_filesize)"
            ncm_options+=("$ncm_counter" "$ncm_display_name")
            ncm_file_paths+=("$ncm_file")
            ((ncm_counter++))
        fi
    done <<< "$ncm_files"
    ncm_options+=(0 "←返回")
    while true
    do
        ncm_choice=$($habit --title "NCM文件列表 (共 $ncm_file_count 个文件)" \
            --menu "请选择" 0 0 10 \
            "${ncm_options[@]}" \
            3>&1 1>&2 2>&3)
        if [ $? -ne 0 ] || [ "$ncm_choice" = "0" ]; then
            break
        elif [ -n "$ncm_choice" ] && [ "$ncm_choice" -ge 1 ] && [ "$ncm_choice" -le $ncm_file_count ]; then
            selected_ncm_file="${ncm_file_paths[$((ncm_choice-1))]}"
            convert_single_ncm "$selected_ncm_file"
        else
            $habit --title "错误" --msgbox "无效的选择" 0 0
        fi
    done
}

convert_single_ncm(){
    local ncm_file="$1"
    local ncm_filename=$(basename "$ncm_file")
    local output_dir=$(dirname "$ncm_file")
    local mp3_file="${ncm_file%.ncm}.mp3"
    $habit --title "转换信息" \
        --msgbox "即将转换:\n\n文件名：$ncm_filename\n原路径：$ncm_file\n输出文件：$mp3_file" 12 60
    echo "正在转换: $ncm_filename"
    if ncmdump "$ncm_file" > "$mp3_file" 2>&1; then
        if [ -f "$mp3_file" ] && [ -s "$mp3_file" ]; then
            local mp3_size=$(du -h "$mp3_file" 2>/dev/null | cut -f1)
            $habit --title "转换成功" \
            --msgbox "转换成功！\n原文件：$ncm_filename\n新文件：$(basename "$mp3_file")\n文件大小：$mp3_size" 12 60
        else
            $habit --title "转换失败" --msgbox "生成了空文件或文件未创建" 0 0
        fi
    else
        local error_msg=$(ncmdump "$ncm_file" 2>&1 | head -5)
        $habit --title "转换失败" --msgbox "转换过程出错：\n$error_msg" 15 60
    fi
}



#Ping检查
check_ping_web(){
    #pkg_install ping
    if [[ "$habit" == "whiptail" ]]; then
        ping_web=$($habit --title "PING检测 (Step 1/2)" \
        --inputbox "请输入网站,例:www.baidu.com" 0 0 \
        2>&1 1>/dev/tty)
    else
        if [[ "$habit" == "dialog" ]]; then
            ping_web=$($habit --colors --title "\Zb PING检测 (Step 1/2) \ZB" \
            --inputbox "请输入网站,例:www.baidu.com" 0 0 \
            2>&1 1>/dev/tty)
        fi
    fi
    while true
    do
        if [[ "$habit" == "whiptail" ]]; then
            count_ping=$($habit --title "PING检测 (Step 2/2)" \
            --inputbox "请输入次数" 0 0 \
            2>&1 1>/dev/tty)
            if [[ "$count_ping" -le "0" ]]; then
                $habit --msgbox "ERR 请输入大于0的有效数字" 0 0
            else
                echo -e "$(info)开始检测网站：$ping_web"
                ping -c $count_ping $ping_web
                esc
                break
            fi
            clear
        else
            if [[ "$habit" == "dialog" ]]; then
                count_ping=$($habit --title "\Zb PING检测  (Step 2/2) \ZB" \
                --inputbox "请输入次数" 0 0 \
                2>&1 1>/dev/tty)
                if [[ "$count_ping" -le "0" ]]; then
                    $habit --msgbox "\Z1 ERR \Zn 请输入大于0的有效数字" 0 0
                else
                    echo -e "$(info)开始检测网站：$ping_web"
                    ping -c $count_ping $ping_web
                    esc
                    break
                fi
                clear
            fi
        fi
    done
}

#随机美图
acg_menu(){
    acg_menu_xz=$($habit --title "随机acg图片" \
    --menu "请选择" 0 0 10 \
    1 "竖屏acg图片" \
    2 "横屏acg图片" \
    3 "仅此修改保存路径" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

#关于naster
about_naster(){
    clear
    echo -e "$pink$(figlet N A S T E R)$color"
    echo -e "naster版本:$green$version$color"
    echo -e "naster贡献名单："
    echo -e "$blue NAS油条 $color        为naster提供了$blue 基础功能 $color以及naster的$blue 其他功能 $color!"
    echo -e "$blue ElectricityDream $color 为naster提供了$blue 修改建议 $color以及naster的$blue 其他功能 $color!"
    echo -e "$blue 小吴 $color            为naster提供了$blue 修改建议 $color以及naster的$blue 其他功能 $color!"
    echo -e "$blue Mit_gancm $color      为naster提供了“$gblue Minecraft服务器部署 $color”功能"
    echo ""
    version_update
    echo -e "$blue目前naster版本：$green$version$color"
    echo -e "本脚本由$blue Hoshino Ai $color 和$blue NAS油条 $color制作!"
    echo -e "NAS油条技术交流群:$green 610699712 $color"
    echo -e "naster Bug反馈群:$green 1079737421 $color"
    read -p "按下Enter键返回"
}

#脚本设置
script_setting(){
    script_setting_xz=$($habit --title "脚本设置" \
    --menu "请选择" 0 0 10 \
    1 "触控方式" \
    2 "自动更新" \
    3 "自动更新包" \
    0 "←返回" \
    3>&1 1>&2 2>&3)
}

index_main(){
    while true
    do
        clear
        main_home
        case $index_menu_xz in
            1)
                echo "系统工具"
                while true
                do
                    pkg_install neofetch
                    clear
                    system_tools
                    case $system_choice in
                        1) 
                            clear
                            neofetch
                            esc
                            clear
                            ;;
                        2) 
                            clear
                            termux-info
                            esc
                            clear
                            ;;
                        3)  
                            clear
                            ifconfig -a
                            esc
                            clear
                            ;;
                        0) 
                            break
                            clear
                            ;;
                    esac
                done
                ;;
            2)
                echo "基础菜单"
                while true
                do
                    basic_tools 
                    case $basic_choice in 
                        1)
                            echo "机器人管理"
                            pkg_install proot-distro
                            clear
                            while true
                            do
                                bot_mannage
                                case $bot_mannage_xz in
                                    1)
                                        while true
                                        do
                                            clear
                                            bot_mannage_set
                                            case $bot_mannage_set_xz in
                                                1)
                                                    proot-distro install debian
                                                    proot-distro login debian -- bash -c 'apt-get install -y sudo'
                                                    proot-distro login debian -- bash -c 'curl -o napcat.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.sh && bash napcat.sh'
                                                    proot-distro login astrbot -- bash -c 'bash <(curl -sSL https://raw.githubusercontent.com/zhende1113/Antlia/refs/heads/main/Script/AstrBot/Antlia.sh)'
                                                    esc
                                                    clear
                                                    ;;
                                                2)
                                                    proot-distro install ubuntu
                                                    proot-distro rename ubuntu astrbot
                                                    proot-distro login astrbot -- bash -c 'bash <(curl -sSL https://raw.githubusercontent.com/zhende1113/Antlia/refs/heads/main/Script/AstrBot/Antlia.sh)'
                                                    esc
                                                    clear
                                                    ;;
                                                3)
                                                    curl -o napcat.termux.sh https://nclatest.znin.net/NapNeko/NapCat-Installer/main/script/install.termux.sh && bash napcat.termux.sh
                                                    esc
                                                    clear
                                                    ;;
                                                4)
                                                    bash <(curl -L gitee.com/TimeRainStarSky/TRSS_OneBot/raw/main/Install.sh)
                                                    esc
                                                    clear
                                                    ;;
                                                0)
                                                    break
                                                    ;;
                                            esac
                                        done
                                        ;;
                                    2)
                                        echo "机器人启动"
                                        while true
                                        do
                                            bot_mannage_start
                                            case $bot_mannage_start_xz in
                                                1)
                                                    proot-distro login astrbot -- bash -c 'cd AstrBot'
                                                    proot-distro login astrbot -- bash -c 'bash astrbot.sh'
                                                    esc
                                                    ;;
                                                2)
                                                    proot-distro login napcat -- bash -c 'xvfb-run -a /root/Napcat/opt/QQ/qq --no-sandbox'
                                                    esc
                                                    ;;
                                                3)
                                                    tsob
                                                    break
                                                    ;;
                                                0)
                                                    break
                                                    ;;
                                            esac
                                        done
                                        ;;
                                    0)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        2)
                            clear
                            echo "容器管理"
                            pkg_install proot-distro
                            while true
                            do
                                clear
                                proot_manage
                                case $proot_mannage_xz in
                                    1)
                                        while true
                                        do
                                            download_proot
                                            case $download_proot_xz in
                                                1) 
                                                    clear
                                                    proot-distro install adelie
                                                    echo -e "请输入$blue proot-distro login adelie $color以启动adelie"
                                                    esc
                                                    break
                                                    ;;
                                                2)
                                                    clear
                                                    proot-distro install almalinux
                                                    echo -e "请输入$blue proot-distro login almalinux $color以启动almalinux"
                                                    esc
                                                    break
                                                    ;;
                                                3)
                                                    clear
                                                    proot-distro install alpine
                                                    echo -e "请输入$blue proot-distro login alpine $color以启动alpine"
                                                    esc
                                                    break
                                                    ;;
                                                4)
                                                    clear
                                                    proot-distro install archlinux
                                                    echo -e "请输入$blue proot-distro login archlinux $color以启动archlinux"
                                                    esc
                                                    break
                                                    ;;
                                                5)
                                                    clear
                                                    proot-distro install artix
                                                    echo -e "请输入$blue proot-distro login artix $color以启动artix"
                                                    esc
                                                    break
                                                    ;;
                                                6)
                                                    clear
                                                    proot-distro install chimera
                                                    echo -e "请输入$blue proot-distro login chimera $color以启动chimera"
                                                    esc
                                                    break
                                                    ;;
                                                7)
                                                    clear
                                                    proot-distro install debian
                                                    echo -e "请输入$blue proot-distro login debian $color以启动debian"
                                                    esc
                                                    break
                                                    ;;
                                                8)
                                                    clear
                                                    proot-distro install fedora
                                                    echo -e "请输入$blue proot-distro login fedora $color以启动fedora"
                                                    esc
                                                    break
                                                    ;;
                                                9)
                                                    clear
                                                    proot-distro install manjaro
                                                    echo -e "请输入$blue proot-distro login manjaro $color以启动manjaro"
                                                    esc
                                                    break
                                                    ;;
                                                10)
                                                    clear
                                                    proot-distro install opensuse
                                                    echo -e "请输入$blue proot-distro login opensuse $color以启动opensuse"
                                                    esc
                                                    break
                                                    ;;
                                                11)
                                                    clear
                                                    proot-distro install oracle
                                                    echo -e "请输入$blue proot-distro login oracle $color以启动oracle"
                                                    esc
                                                    break
                                                    ;;
                                                12)
                                                    clear
                                                    proot-distro install pardus
                                                    echo -e "请输入$blue proot-distro login pardus $color以启动pardus"
                                                    esc
                                                    break
                                                    ;;
                                                13)
                                                    clear
                                                    proot-distro install rockylinux
                                                    echo -e "请输入$blue proot-distro login rockylinux $color以启动rockylinux"
                                                    esc
                                                    break
                                                    ;;
                                                14)
                                                    clear
                                                    proot-distro install termux
                                                    echo -e "请输入$blue proot-distro login termux $color以启动termux"
                                                    esc
                                                    break
                                                    ;;
                                                15)
                                                    clear
                                                    proot-distro install trisquel
                                                    echo -e "请输入$blue proot-distro login trisquel $color以启动trisquel"
                                                    esc
                                                    break
                                                    ;;
                                                16)
                                                    clear
                                                    proot-distro install ubuntu
                                                    echo -e "请输入$blue proot-distro login ubuntu $color以启动ubuntu"
                                                    esc
                                                    break
                                                    ;;
                                                17)
                                                    clear
                                                    proot-distro install void
                                                    echo -e "请输入$blue proot-distro login void $color以启动void"
                                                    esc
                                                    break
                                                    ;;
                                                0)
                                                    break
                                                    ;;
                                            esac
                                        done
                                        ;;
                                    2)
                                        clear
                                        start_dialog_proot
                                        clear
                                        ;;
                                    3)
                                        clear
                                        remove_dialog_proot
                                        ;;
                                    0)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        3)
                            while true
                            do
                                clear
                                baka
                                case $baka_xz in
                                    1)
                                        echo -e "$(info)即将开始下载Alist挂载工具..."
                                        pkg_install alist
                                        if command -v alist >/dev/null 2>&1; then
                                            sleep 0.1
                                        else
                                            echo -e "$(warn)你似乎缺少了alist资源包"
                                            sleep 1
                                            break
                                        fi
                                        $habit --title "是否启动" --yesno "是否现在启动alist？" 0 0
                                        if [ $? -eq 0 ]; then
                                            while true
                                            do
                                                echo -e "是否在后台运行？"
                                                echo "1.前台运行（不支持对其他人开放）"
                                                echo "2.后台运行（支持对其他人开放）"
                                                echo "0.←返回"
                                                read -p ">>>" run_xz
                                                case $run_xz in
                                                    1)
                                                        alist server
                                                        break
                                                        ;;
                                                    2)
                                                        echo -e "$(info)正在安装tmux..."
                                                        pkg_install tmux
                                                        echo -e "$(info)创建环境中..."
                                                        tmux new -s alist
                                                        echo -e "若想返回termux，请点击Ctrl+B再加D即可返回"
                                                        read -p "若已了解，请点击回车键以进行下一步，Ctrl+C退出！"
                                                        alist server
                                                        ;;
                                                    0)
                                                        break
                                                        ;;
                                                esac
                                                $habit --title "确认操作" --yesno "是否对其他人开放？" 0 0
                                                if [ $? -eq 0 ]; then
                                                    echo -e "$(info)正在安装cloudflare..."
                                                    pkg_install cloudflared
                                                    echo -e "$(info)正在尝试开放中..."
                                                    $habit --msgbox "运行成功后，它会生成一个类似  xxxx.trycloudflare.com  的链接，直接把这个链接发给别人即可" 0 0
                                                    cloudflared tunnel --url http://localhost:5244
                                                    break
                                                else
                                                    break
                                                fi
                                            done
                                        else
                                            break
                                        fi
                                        ;;
                                    0)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        0)
                            break
                            ;;
                    esac
                done
                ;;
            3)
                echo "实验脚本"
                clear
                while true
                do
                    test_shell
                    case $test_shell_xz in
                        1)
                            while true
                            do
                                qemu_shell
                                case $qemu_shell_xz in
                                    1)
                                        clear
                                        echo -e "$green 正在下载QEMU以及相关工具🤓 $color"
                                        pkg update && pkg upgrade
                                        clear
                                        pkg_install qemu-system-x86-64-headless qemu-utils -y
                                        read -p "请输入ISO文件下载网址🤓：" iso_download_url
                                        read -p "请输入ISO文件名（无需输入后缀）🤓:" name_iso
                                        wget -O $name_iso.iso "$iso_download_url"
                                        clear
                                        read -p "磁盘名🤓(.img)（无需加后缀名）：" disk_name
                                        read -p "磁盘内存🤓(G)（只用输入数字）:" disk_size
                                        qemu-img create -f qcow2 $disk_name.img $disk_size
                                        clear
                                        echo "正在通过VNC查看安装界面..."
                                        sleep 1
                                        qemu-system-x86_64 -msg timestamp=on 2>/dev/null
                                        qemu-system-x86_64 -boot menu=on,edd=off -m 2G -hda $disk_name.img
                                        qemu-system-x86_64 -m 2G -vga qxl -net user -net nic,model=virtio -vnc :3 -cpu Skylake-Server -smp 8 -drive file=$disk_name.img,format=qcow2 -cdrom $name_iso.iso
                                        esc
                                        ;;
                                    2)
                                        clear
                                        cd /data/data/com.termux/files/home
                                        read -p "请输入你已安装的.iso文件（无需加后缀名）：" finish_download_iso
                                        read -p "请输入磁盘名称：" disk_have
                                        qemu-system-x86_64 -msg timestamp=on 2>/dev/null
                                        qemu-system-x86_64 -boot menu=on,edd=off -m 2G -hda $disk_have.img
                                        qemu-system-x86_64 -m 2G -vga qxl -net user -net nic,model=virtio -vnc :3 -cpu Skylake-Server -smp 8 -drive file=$disk_have.img,format=qcow2 -cdrom $finish_download_iso.iso
                                        break
                                        ;;
                                    3)
                                        clear
                                        read -p "请输入你要扩展的.img文件（无需加后缀名）" input_img
                                        read -p "请输入你要加的内存（G）（只需输入数字）：" add_GB
                                        qemu-img resize $input_img.img +$add_GB G
                                        cfdisk /dev/sda
                                        resize2fs /dev/sda2
                                        echo "扩展完成"
                                        esc
                                        ;;
                                    0)
                                        break
                                        ;;
                                esac
                            done
                            ;;
                        0)
                            break
                            ;;
                    esac
                done
                ;;
            4)
                echo "其他工具"
                clear
                while true
                do
                    other_shell
                    case $other_shell_xz in
                    1)
                        clear
                        wget -O install-nethunter-termux https://offs.ec/2MceZWr
                        chmod +x install-nethunter-termux
                        ./install-nethunter-termux
                        break
                        ;;
                    2)
                        while true
                        do
                            pkg_install android-tools
                            if adb devices | grep -q "device$"; then
                                adb_tool_pair
                            else
                                adb_tool_unpair
                            fi
                            case $adb_tool_xz in
                                1)
                                    echo -e "$(info)即将开始配对！"
                                    echo -e "$red注意！$color该功能只能在Android11及以上的手机才能使用！"
                                    read -p "请转到手机“设置”，找到“关于手机”，点击7次“软件版本号”开启“开发者模式”！（回车进行下一步）"
                                    read -p "找到“开发者选项”并启用，然后往下找到“无线调试”，点击竖线旁边的空白区域打开无线调试界面（回车进行下一步）"
                                    read -p "打开“无线调试”的开关，然后将Termux挂至小窗，返回“设置”，选择“六位数配对码”，然后在Termux点击回车以输入IP以及端口号，输入完后，其次输入配对码（回车进行下一步）"
                                    adb_pair_ip=$($habit --title "IP地址和端口号" \
                                    --inputbox "格式：<IP地址>:<端口号>，如：114.114.0.114:11451" 0 0 \
                                    3>&1 1>&2 2>&3)
                                    adb pair $adb_pair_ip
                                    read -p "现在，你已完成配对，现在请输入无限调试界面的IP地址和端口"
                                    adb_tool_connect=$($habit --title "Connect" \
                                    --inputbox "IP地址和端口号：" 0 0 \
                                    3>&1 1>&2 2>&3)
                                    adb connect $adb_tool_connect
                                    if adb devices | grep -q "device$"; then
                                        echo -e "$(info)设备已连接！"
                                        sleep 1
                                    else
                                        echo -e "$(warn)设备未连接！"
                                        sleep 1
                                    fi
                                    break
                                    ;;
                                2)
                                    while true
                                    do
                                        if adb shell netstat -tulpn 2>/dev/null | grep -q "6857"; then
                                            echo -e "$(info)Shizuku已激活"
                                            break
                                        else
                                            echo -e "$(info)正在激活Shizuku..."
                                            adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh
                                            break
                                        fi
                                    done
                                    break
                                    ;;
                                3)
                                    read -p "请先在Scene中选择ADB模式！（回车以开始激活）"
                                    while true
                                    do
                                        if adb shell dumpsys activity services | grep -q "com.omarea.vtools"; then
                                            echo -e "$(info)Scene已激活"
                                            break
                                        else
                                            echo -e "$(info)正在激活Scene..."
                                            adb shell sh /storage/emulated/0/Android/data/com.omarea.vtools/up.sh
                                            break
                                        fi
                                    done
                                    break
                                    ;;
                                4)
                                    while true
                                    do
                                        if adb ps | grep -q "axmanager"; then
                                            echo -e "$(info)AxManager已激活"
                                            break
                                        else
                                            echo -e "$(info)正在激活AxManager..."
                                            adb shell /data/app/~~IU-4UcLn-3zAacBqcq0vKg==/frb.axeron.manager-xCgNDl6H9pok5xe-mXoG4g==/lib/arm64/libaxeron.so
                                            break
                                        fi
                                        clear
                                    done
                                    break
                                    ;;
                                5)
                                    while true
                                    do
                                        adb_other_shell
                                        case $adb_other_shell_xz in
                                            1)
                                                adb shell screencap -p /sdcard/screenshot.png
                                                chafa /sdcard/screenshot.png
                                                rm -r /sdcard/screenshot.png
                                                esc
                                                ;;
                                            2)
                                                adb reboot
                                                esc
                                                ;;
                                            3)
                                                adb reboot fastboot
                                                esc
                                                ;;
                                            4)
                                                adb reboot recovery
                                                esc
                                                ;;
                                            5)
                                                adb reboot edl
                                                esc
                                                ;;
                                            6)
                                                adb_other_input=$($habit --title "请输入adb指令" \
                                                --inputbox "自动加前缀adb shell" 0 0 \
                                                2>&1 1>/dev/tty)
                                                adb shell $adb_other_input
                                                esc
                                                ;;
                                            0)
                                                break
                                                ;;  
                                        esac
                                    done
                                    ;;
                                6)
                                    read -p "请在“无线调试”界面找到你的IP和端口号，按下回车以输入"
                                    adb_device_connect_text=$($habit --title "IP和端口号" \
                                    --inputbox "格式：<IP地址>:<端口号>，如：114.114.0.114:11451" 0 0 \
                                    2>&1 1>/dev/tty)
                                    adb connect $adb_device_connect_text
                                    break
                                    ;;
                                0)
                                    break
                                    ;;
                            esac
                        done
                        ;;
                    3)
                        clear
                        pkg_install mpv
                        while true
                        do
                            clear
                            music_player
                            case $music_player_xz in
                                1)
                                    clear
                                    files_music=$($habit --title "内部存储" \
                                    --inputbox "请输入路径" 0 40 \
                                    2>&1 1>/dev/tty)
                                    if [ -e "$files_music" ]; then
                                        $habit --title "再次确认" --yesno "是否确定定位到$files_music?" 0 0
                                    else
                                        $habit --title "错误！" --msgbox "路径错误！请重试！" 0 0
                                        break
                                    fi
                                    clear
                                    search_and_play_mp3
                                    ;;
                                3)
                                    clear
                                    echo -e "网易云歌曲保存路径是否位于:$blue/storage/emulated/0/Download/netease/cloudmusic/Music/$color"
                                    echo "1.是"
                                    echo "2.否"
                                    read -p ">>>" location_netease
                                    case $location_netease in
                                        1)
                                            localmusic_netease=/storage/emulated/0/Download/netease/cloudmusic/Music/
                                            pkg_install python python-pip
                                            pkg_install git
                                            cd $HOME
                                            python -m venv .venv
                                            source "$HOME/.venv/bin/activate"
                                            pip install requests -i https://mirrors.aliyun.com/pypi/simple
                                            pip install --upgrade pip
                                            pip install ncmdump
                                            clear
                                            ncm_converter
                                            ;;
                                        2)
                                            chang_netease_location=$($habit --title "更改路径" \
                                            --inputbox "请输入.ncm文件位置" 0 0 \
                                            2>&1 1>/dev/tty)
                                            if [ -e "$chang_netease_location" ]; then
                                                $habit --title "再次确认" --yesno "是否确定定位到$chang_netease_location?" 0 0
                                            else
                                                $habit --title "错误！" --msgbox "路径错误！请重试！" 0 0
                                                break
                                            fi
                                            localmusic_netease=$change_netease_location
                                            pkg_install python
                                            pkg_install git
                                            pip install ncmdump
                                            clear
                                            ncm_converter
                                            ;;
                                        *)
                                            echo "返回"
                                            break
                                            ;;
                                    esac
                                    ;;
                                0)
                                    break
                                    ;;
                            esac
                        done
                        ;;
                    4)
                        clear
                        check_ping_web
                        clear
                        ;;
                    0)
                        break
                        ;;
                    esac
                done
                ;;
            5)
                echo "其他脚本"
                while true
                do
                    clear
                    other_script
                    case $other_script_xz in
                        1)
                            pkg update && pkg upgrade -y
                            git clone https://gitee.com/MIt-gancm/Autumn-leaves ~/.gancm
                            bash ~/.gancm/gancm.sh
                            break
                            ;;
                        2)
                            if command -v nasyt >/dev/null 2>&1; then
                                #echo "nasyt66"
                                nasyt
                            else
                                bash -c "$(curl -L https://raw.gitcode.com/nasyt/nasyt-linux-tool/raw/master/nasyt_install.sh)"
                            fi
                            break
                            ;;
                        0)
                            break
                            ;;
                    esac
                done
                ;;
            6)
                while true
                do
                    clear
                    pkg_install chafa
                    acg_menu
                    case $acg_menu_xz in
                        1)
                            mkdir -p $save_place
                            total=1
                            clear
                            echo -e "$red注意：$color将终端缩小至合适比例已获取最佳效果!"
                            echo -e "$blue请在下方输入生成的张数$color（默认为1）"
                            read -p ">>>" user_need
                            while true
                            do
                                if [[ "$total" == "$user_need" ]]; then
                                    echo -e "第$blue$total$color张"
                                    tp_curl=https://www.loliapi.com/acg/pe
                                    time_name_xz=()
                                    local tp_time=$(date +%Y%m%d_%H%M%S)
                                    local random=$(shuf -i 1000-9999 -n 1)
                                    local tp_pid_2=$(echo "_$tp_pid")
                                    local api_r18_2=$(echo "_$tp_r18")
                                    time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                    wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                    chafa $save_place/$time_name_xz.png
                                    echo -e "$(info) 图片已保存在$save_place/$time_name_xz.png"
                                    esc
                                    break
                                else
                                    if [[ "$user_need" -lt "0" ]]; then
                                        echo -e "请输入$red大于0$color的数字！"
                                    fi
                                fi
                                if [[ "$total" -lt "$user_need" ]]; then
                                    echo -e "第$blue$total$color张"
                                    tp_curl=https://www.loliapi.com/acg/pe
                                    time_name_xz=()
                                    local tp_time=$(date +%Y%m%d_%H%M%S)
                                    local random=$(shuf -i 1000-9999 -n 1)
                                    local tp_pid_2=$(echo "_$tp_pid")
                                    local api_r18_2=$(echo "_$tp_r18")
                                    time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                    wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                    chafa $save_place/$time_name_xz.png
                                    total=$((total + 1))
                                fi
                                if [[ "$total" == "1" ]]; then
                                    echo -e "第$blue$total$color张"
                                    tp_curl=https://www.loliapi.com/acg/pe
                                    time_name_xz=()
                                    local tp_time=$(date +%Y%m%d_%H%M%S)
                                    local random=$(shuf -i 1000-9999 -n 1)
                                    local tp_pid_2=$(echo "_$tp_pid")
                                    local api_r18_2=$(echo "_$tp_r18")
                                    time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                    wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                    chafa $save_place/$time_name_xz.png
                                    echo -e "$(info) 图片已保存在$save_place/$time_name_xz.png"
                                    esc
                                    break
                                    fi
                            done
                            ;;
                        2)
                            mkdir -p $save_place/
                            total=1
                            clear
                            echo -e "$red注意：$color将终端缩小至合适比例已获取最佳效果!"
                            echo -e "$blue请在下方输入生成的张数$color（默认为1）"
                            read -p ">>>" user_need
                            while true
                            do
                                if [[ "$total" == "$user_need" ]]; then
                                    echo -e "第$blue$total$color张"
                                    tp_curl=https://www.loliapi.com/acg/pc
                                    time_name_xz=()
                                    local tp_time=$(date +%Y%m%d_%H%M%S)
                                    local random=$(shuf -i 1000-9999 -n 1)
                                    local tp_pid_2=$(echo "_$tp_pid")
                                    local api_r18_2=$(echo "_$tp_r18")
                                    time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                    wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                    chafa $save_place/$time_name_xz.png
                                    echo -e "$(info) 图片已保存在$save_place/$time_name_xz.png"
                                    esc
                                    break
                                else
                                    if [[ "$user_need" -lt "0" ]]; then
                                        echo -e "请输入$red大于0$color的数字！"
                                        read
                                        break
                                    fi
                                fi
                                if [[ "$total" -lt "$user_need" ]]; then
                                    echo -e "第$blue$total$color张"
                                    tp_curl=https://www.loliapi.com/acg/pc
                                    time_name_xz=()
                                    local tp_time=$(date +%Y%m%d_%H%M%S)
                                    local random=$(shuf -i 1000-9999 -n 1)
                                    local tp_pid_2=$(echo "_$tp_pid")
                                    local api_r18_2=$(echo "_$tp_r18")
                                    time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                    wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                    chafa $save_place/$time_name_xz.png
                                    total=$((total + 1))
                                fi
                                if [[ "$total" == "1" ]]; then
                                    echo -e "第$blue$total$color张"
                                    tp_curl=https://www.loliapi.com/acg/pe
                                    time_name_xz=()
                                    local tp_time=$(date +%Y%m%d_%H%M%S)
                                    local random=$(shuf -i 1000-9999 -n 1)
                                    local tp_pid_2=$(echo "_$tp_pid")
                                    local api_r18_2=$(echo "_$tp_r18")
                                    time_name_xz+="${tp_time}${tp_pid_2}${api_r18_2}"
                                    wget -O $save_place/$time_name_xz.png "$tp_curl" >/dev/null 2>&1
                                    chafa $save_place/$time_name_xz.png
                                    echo -e "$(info) 图片已保存在$save_place/$time_name_xz.png"
                                    esc
                                    break
                                fi
                            done
                            ;;
                        3)
                            echo "切换路径"
                            clear
                            save_place=$($habit --title "修改路径(末尾自动带\)" \
                            --inputbox "文字" 0 0 \
                            3>&1 1>&2 2>&3)
                            if [ "$save_place" == "" ]; then
                            echo -e "$(warn)在修改路径时发生错误！"
                                sleep 1
                            else
                                if [ -e "$save_place" ]; then
                                    echo -e "$(info)路径存在,本次路径已修改为:$save_place"
                                else
                                    echo -e "$(warn)路径不存在,请重新修改！已使用默认路径！"
                                    save_place=$HOME/.nasyt/acg
                                    sleep 1
                                fi
                            fi
                            ;;
                        4)
                            break
                            ;;
                    esac
                    break
                done
                ;;
            7)
                about_naster
                ;;
            8)
                clear
                gx_show
                clear
                ;;
            9)
                while true
                do
                    script_setting
                    case $script_setting_xz in
                        1)
                            habit_rechoice=$habit --title "触控方式" \
                            --menu "当前触控方式为:$habit" 0 0 10 \
                            1 "dialog" \
                            2 "whiptail" \
                            0 "←返回" \
                            3>&1 1>&2 2>&3)
                            case $habit_rechoice in
                            1)
                                habit=dialog
                                update_config "habit" "$habit"
                                $habit --title "设置成功！" --msgbox "已将触控方式修改为dialog!请重启naster!" 0 0
                                ;;
                            2)
                                habit=whiptail
                                update_config "habit" "$habit"
                                $habit --title "设置成功！" --msgbox "已将触控方式修改为whiptail!请重启naster!" 0 0
                                ;;
                            0)
                                break
                                ;;
                            esac
                            ;;
                        2)
                            auto_update_rechoice=$habit --title "自动更新" \
                            --menu "当前自动更新状态为:$auto_update" 0 0 10
                            1 "开启" \
                            2 "关闭" \
                            0 "←返回" \
                            3>&1 1>&2 2>&3)
                            case $auto_update_rechoice in
                            1)
                                auto_update=true
                                update_config "auto_update" "$auto_update"
                                $habit --title "设置成功！" --msgbox "已将自动更新修改为true!请重启naster!" 0 0
                                ;;
                            2)
                                auto_update=false
                                update_config "auto_update" "$auto_update"
                                $habit --title "设置成功！" --msgbox "已将自动更新修改为false!请重启naster!" 0 0   
                                ;;
                            0)
                                break
                                ;;
                            esac
                            ;;
                        3)
                            auto_update_pkg_rechoice=$habit --title "自动更新包" \
                            --menu "当前自动更新包状态为:$auto_update_pkg" 0 0 10 \
                            1 "开启" \
                            2 "关闭" \
                            0 "←返回" \
                            3>&1 1>&2 2>&3)
                            case $auto_update_pkg_rechoice in
                            1)
                                auto_update_pkg=true
                                update_config "auto_update_pkg" "$auto_update_pkg"
                                $habit --title "设置成功！" --msgbox "已将自动更新包修改为true!请重启naster!" 0 0
                                ;;
                            2)
                                auto_update_pkg=false
                                update_config "auto_update_pkg" "$auto_update_pkg"
                                $habit --title "设置成功！" --msgbox "已将自动更新包修改为false!请重启naster!" 0 0
                                ;;
                            0)
                                break
                                ;;
                            esac
                            ;;
                        0)
                            break
                            ;;
                    esac
                done
            0)
                exit 0
                ;;
        esac
    done
}

info(){
    echo -e "$cyan[$(date +"%r")]$color $green[INFO]$color" $*
}

warn(){
    echo -e "$cyan[$(date +"%r")]$color $yellow[WARN]$color" $*
}

fail(){
    echo -e "$cyan[$(date +"%r")]$color $red[FAIL]$color" $*
}

#🤓运行部分-----------------
clear #清屏
cd $HOME #进入HOME目录
color_variable #加载颜色函数
main #加载主函数