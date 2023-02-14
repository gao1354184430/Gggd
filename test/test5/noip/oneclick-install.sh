#!/bin/bash

# 获取命令行参数
noip_account=$1
noip_password=$2
ddns_domain=$3

# 检查操作系统版本
if [[ -e /etc/os-release ]]; then
    . /etc/os-release
    os=$ID
    version=$VERSION_ID
else
    echo "Error: This script only supports CentOS 7, Debian and Ubuntu."
    exit 1
fi

# 安装依赖项
case $os in
    centos)
        if [[ $version == "7" ]]; then
            yum -y install wget make gcc openssl-devel
        else
            echo "Error: This script only supports CentOS 7."
            exit 1
        fi
        ;;
    debian|ubuntu)
        apt-get update
        apt-get -y install wget make gcc libssl-dev
        ;;
    *)
        echo "Error: This script only supports CentOS 7, Debian and Ubuntu."
        exit 1
        ;;
esac

# 安装noip客户端
cd /usr/local/src/
wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz
tar xf noip-duc-linux.tar.gz
cd noip-2.1.9-1/
make
make install

# 创建noip配置文件
cat <<EOF >/usr/local/etc/no-ip2.conf
# Configuration file for noip2.
# /usr/local/etc/no-ip2.conf
# 
# Updated: Sat Feb 13 00:00:12 PST 2021
#
# Use your account and password to login

#日志文件位置
#logfile=/tmp/noip.log

#设置向no-ip注册的账号和密码
username=${noip_account}
password=${noip_password}

#设置要DDNS更新的域名
use=web, web=${ddns_domain}
EOF

# 创建systemd服务文件
cat <<EOF >/etc/systemd/system/noip2.service
[Unit]
Description=No-IP Dynamic DNS Update Client
After=network.target

[Service]
ExecStart=/usr/local/bin/noip2
Restart=always
Type=forking

[Install]
WantedBy=multi-user.target
EOF

# 启动noip2服务
systemctl enable noip2.service
systemctl start noip2.service
