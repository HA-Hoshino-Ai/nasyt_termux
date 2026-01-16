#!/bin/bash
install_main(){
    echo "正在查找naster新版本..."
    clear
    version_update
    echo -e "naster最新版本:$green$new_version$color!"
    echo -e "$green$(curl -s "https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/update.txt")$color"
    echo -e "$grey——————————————————————————————————$color"
    echo "1.下载naster脚本✨"
    echo "2.补全naster资源✨"
    echo "3.降低naster版本✨"
    echo "4.其他naster版本✨️"
    echo "0.退出"
    read -p ">>>" install_xz
    case $install_xz in
        1)
            clear
            echo -e "$(info)检查前置脚本..."
            if command -v nasyt >/dev/null 2&>1;  then
                echo -e "$(info)已安装前置脚本！"
                sleep 0.5
                echo -e "$(info)检查脚本是否安装..."
                sleep 0.5
                if command -v naster >/dev/null 2>&1 ; then
                    echo -e "$(info)检测到脚本！"
                    sleep 0.5
                    echo -e "$(info)输入$pink naster $color以启动脚本！"
                    exit 0
                else
                    echo -e "$(warn)未检测到脚本！"
                    sleep 0.5
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
                            curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/a18227009509-coder/nasyt_termux/master/nasyt_termux.sh
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
                fi
            else
                clear
                echo -e "$(info)下载前置脚本..."
                bash -c "$(curl -L -s https://raw.gitcode.com/nasyt/nasyt-linux-tool/raw/master/nasyt_install.sh)"
                clear
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
                        curl -L -s -o $HOME/.nasyt/naster  https://gh-proxy.com/https://raw.githubusercontent.com/a18227009509-coder/nasyt_termux/master/nasyt_termux.sh
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
            fi
            ;;
        2)
            echo -e "$(info)开始检查pkg包..."
            if command -v pkg &>/dev/null ; then
                echo -e "$(info)已检测到pkg包，稍后会使用pkg install安装"
                must_pkg_install
            else
                echo -e "$(info)开始检查apt包..."
                if command -v apt &>/dev/null ; then
                    echo -e "$(info)已检测到apt包，稍后会使用apt install安装"
                    apt update && apt upgrade
                    clear
                    sleep 0.5
                    echo -e "$(info)开始下载资源..."
                    must_apt_install
                else
                    echo -e "$(fail)无法检测pkg/apt包！"
                    exit 0
                fi
            fi
            ;; 
        3)
            echo -e "$(info)正在检查已有版本..."
            if command -v naster >/dev/null 2>&1; then
                clear
                echo "(info)正在删除当前已有版本"
                rm -r $HOME/.nasyt/naster
            fi
            echo -e "(info)选择你想要下载的版本"
            echo "(1)2.0.51"
            echo "(2)2.0.5"
            echo "←返回"
            read -p ">>>" downdate_xz
            case $downdate_xz in
                1)
                    break
                    ;;
                2)
                    echo -e "$(info)请稍候..."
                    sleep 2
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
                3)
                    exit 0
                    ;;
            esac
            ;;
        4)
            exit 0
            ;;
    esac
}

version_update() {
    new_version=$(curl -s "https://gitee.com/HA-Hoshino-Ai/nasyt_termux/raw/master/version.txt") 
}

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

info(){
    echo -e "$cyan[$(date +"%r")]$color $green[INFO]$color" $*
}

warn(){
    echo -e "$cyan[$(date +"%r")]$color $yellow[WARN]$color" $*
}

fail(){
    echo -e "$cyan[$(date +"%r")]$color $red[FAIL]$color" $*
}

pkg_install() {
    pkg_install_app="$*" 
    if command -v $pkg_install_app >/dev/null 2>&1; then
        echo -e "$green $pkg_install_app已经安装，跳过步骤$color"
    else 
        echo "正在安装$pkg_install_app"
        pkg install -y $pkg_install_app >/dev/null; 
        if [ $? -ne 0 ]; then
            echo -e "$(info)安装成功 $color"
        else
            echo -e "$(warn)安装失败 $color"
        fi
    fi
}

must_pkg_install() {
    echo -e "$(info)正在检查必备软件包安装..."
    pkg_install curl
    pkg_install proot-distro
    pkg_install neofetch
    pkg_install figlet
    pkg_install wget
    pkg_install git
    pkg_install make
    pkg_install cmake
    pkg_install clang
}

apt_install() {
    apt_install_app="$*" 
    if command -v $apt_install_app >/dev/null 2>&1; then
        echo -e "$green $apt_install_app已经安装，跳过步骤$color"
    else 
        echo "正在安装$apt_install_app"
        apt install -y $apt_install_app >/dev/null; 
        if [ $? -ne 0 ]; then
            echo -e "$(info)安装成功 $color"
        else
            echo -e "$(warn)安装失败 $color"
        fi
    fi
}

must_apt_install() {
    echo "正在检查必备软件包安装"
    apt_install curl
    apt_install fastfetch
    apt_install figlet
    apt_install wget
    apt_install git
    apt_install make
    apt_install cmake
    apt_install clang
}

color_variable
install_main