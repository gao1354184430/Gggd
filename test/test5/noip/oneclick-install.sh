#!/bin/bash

# 获取命令行传递的ddns域名参数
ddns_domain="$1"

# 定义noip账号和密码
noip_username="gao1354184430@gmail.com"
noip_password="fV$XQZz8PTt@B4."

# 检查操作系统类型，使用不同的安装命令和服务管理工具
if [[ $(cat /etc/os-release) == *"CentOS"* ]]; then
    # 安装noip客户端
    sudo yum install -y wget gcc make
    wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz -O /tmp/noip-duc-linux.tar.gz
    tar xf /tmp/noip-duc-linux.tar.gz -C /tmp/
    cd /tmp/noip-2.1.9-1/
    make
    sudo make install

    # 创建systemd服务文件
    sudo tee /etc/systemd/system/noip2.service > /dev/null <<EOF
[Unit]
Description=noip2 Dynamic DNS Update Client
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/bin/noip2
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

    # 配置noip客户端
    sudo sed -i "s/^\s*#*username=.*/username=${noip_username}/" /usr/local/etc/no-ip2.conf
    sudo sed -i "s/^\s*#*password=.*/password=${noip_password}/" /usr/local/etc/no-ip2.conf
    sudo sed -i "s/^\s*#*host=.*/host=${ddns_domain}/" /usr/local/etc/no-ip2.conf

    # 重新加载systemd配置
    sudo systemctl daemon-reload

    # 启动noip2服务并设置自启动
    sudo systemctl start noip2.service
    sudo systemctl enable noip2.service

elif [[ $(cat /etc/os-release) == *"Debian"* ]] || [[ $(cat /etc/os-release) == *"Ubuntu"* ]]; then
    # 安装noip客户端
    sudo apt-get update
    sudo apt-get install -y build-essential
    wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz -O /tmp/noip-duc-linux.tar.gz
    tar xf /tmp/noip-duc-linux.tar.gz -C /tmp/
    cd /tmp/noip-2.1.9-1/
    make
    sudo make install

    # 创建systemd服务文件
    sudo tee /etc/systemd/system/noip2.service > /dev/null <<EOF
[Unit]
Description=noip2 Dynamic DNS Update Client
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/bin/noip2
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

    # 配置noip客户端
    sudo sed -i "s/^\s*#*username=.*/username=${noip_username}/" /usr/local/etc/no-ip2.conf
    sudo sed -i "s/^\s*#*password=.*/password=${noip_password}/" /usr/local/etc/no-ip2.conf
    sudo sed -i "s/^\s*#*host=.*/host=${ddns_domain}/" /usr/local/etc/no-ip2.conf

    # 重新加载systemd配置
   
sudo systemctl daemon-reload
# 启动noip2服务并设置自启动
sudo systemctl start noip2.service
sudo systemctl enable noip2.service
else
echo "不支持的操作系统类型"
exit 1
fi
echo "noip ddns服务已部署成功！"
