#!/bin/bash

# 获取命令行传递的ddns域名参数
ddns_domain=$1

# 设置noip账号和密码
noip_username="gao1354184430@gmail.com"
noip_password="fV$XQZz8PTt@B4."

# 安装noip客户端
sudo apt-get update
sudo apt-get install noip2

# 配置noip客户端
sudo sed -i "s/^\s*#*username=.*/username=${noip_username}/" /usr/local/etc/no-ip2.conf
sudo sed -i "s/^\s*#*password=.*/password=${noip_password}/" /usr/local/etc/no-ip2.conf
sudo sed -i "s/^\s*#*host=.*/host=${ddns_domain}/" /usr/local/etc/no-ip2.conf

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

# 重新加载systemd配置
sudo systemctl daemon-reload

# 启动noip2服务并设置自启动
sudo systemctl start noip2.service
sudo systemctl enable noip2.service

echo "noip ddns服务已部署成功！"
