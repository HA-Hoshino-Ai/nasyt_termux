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
    echo "3.下载其他版本✨"
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
                        curl -L -s -o .nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/321b5fc06699d1e9125f4197e6bd7a02c7b3914f/nasyt_termux.sh
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
                    curl -L -s -o .nasyt/naster https://gitcode.com/HA-Hoshino_Ai/nasyt_termux/raw/321b5fc06699d1e9125f4197e6bd7a02c7b3914f/nasyt_termux.sh
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

color_variable
install_main