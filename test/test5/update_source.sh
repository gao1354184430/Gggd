#!/bin/bash

# 备份源列表文件
cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 将原有源列表文件替换为清华源列表
echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free" > /etc/apt/sources.list

# 更新源
apt-get update
