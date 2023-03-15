#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE="\033[0;35m"
CYAN='\033[0;36m'
PLAIN='\033[0m'

checkroot(){
	[[ $EUID -ne 0 ]] && echo -e "${RED}请使用 root 用户运行本脚本！${PLAIN}" && exit 1
}

preinfo() {
	clear
    echo "———————————————————番茄V2 Trojan配置一键脚本———————————————————————"
    echo "       适用系统：CentOS 7.X"
	echo "       脚本更新: 2023/03/14"
	echo "       作者：饭桶LemonTea"
	echo "——————————————————————————————————————————————————————————————————"
	sleep 3
	echo -e "${RED}水平有误，出现任何问题请立即使用手动配置环境，不要找我麻烦！${PLAIN}"
	sleep 3
	echo -e "${RED}建议只运行一遍脚本即可，不要多次重复运行，否则大概率会出问题！！${PLAIN}"
	sleep 3
	clear
}

checkwget() {
	if  [ ! -e '/usr/bin/wget' ]; then
	        echo -e "${YELLOW}正在安装 Wget${PLAIN}"
	                yum update > /dev/null 2>&1
	                yum -y install wget > /dev/null 2>&1
				clear
	fi
}


checknginx() {
	if  [ ! -e '/usr/local/nginx' ]; then
	        echo -e "${YELLOW}正在安装 tengine负载支持DDNS/主动健康检查${PLAIN}"
			sleep 5
	
        yum update -y
        yum install epel-release -y
        yum install gcc gcc-c++ autoconf automake -y
        yum install pcre-devel -y
        yum install openssl-devel -y
        yum install libmcrypt libmcrypt-devel mcrypt mhash -y
		yum install kernel-headers kernel-devel make -y
		rm -rf /usr/local/nginx
        rm -rf /root/tengine*
		cd /root
		wget --no-check-certificate --no-check-certificate http://tengine.taobao.org/download/tengine-2.3.3.tar.gz
		tar zxvf tengine-2.3.3.tar.gz
        cd /root/tengine-2.3.3/
		./configure --with-http_realip_module --without-http_upstream_keepalive_module --with-stream --with-stream_ssl_module --with-stream_sni --add-module=modules/ngx_http_upstream_* --add-module=modules/ngx_debug_* --add-module=modules/ngx_http_slice_module --add-module=modules/ngx_http_user_agent_module --add-module=modules/ngx_http_reqstat_module --add-module=modules/ngx_http_proxy_connect_module --add-module=modules/ngx_http_footer_filter_module
#        ./configure --with-http_realip_module --without-http_upstream_keepalive_module --with-stream --with-stream_ssl_module --with-stream_sni --add-module=modules/ngx_http_upstream_check_module --add-module=modules/ngx_debug_pool --add-module=modules/ngx_http_slice_module --add-module=modules/ngx_http_user_agent_module --add-module=modules/ngx_http_reqstat_module --add-module=modules/ngx_http_proxy_connect_module --add-module=modules/ngx_http_footer_filter_module
        make
        make install
        mkdir /usr/local/nginx/tcp
		mkdir /usr/local/nginx/cert
        wget --no-check-certificate --no-check-certificate -N -P /usr/local/nginx/ $cndownload/download/ws
        echo "user  root;
worker_processes auto;
worker_rlimit_nofile 51200;
pid        /usr/local/nginx/logs/nginx.pid;
events
    {
        use epoll;
        worker_connections 51200;
        multi_accept on;
    }
stream {
    include /usr/local/nginx/tcp/*.conf;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  120;
    keepalive_requests 10000;
    check_shm_size 50m;
    access_log  off;
    #vmess-ws
    include /usr/local/nginx/*.conf;
}">/usr/local/nginx/conf/nginx.conf
		echo "[Unit]
Description=The nginx HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target
 
[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
PrivateTmp=true
 
[Install]
WantedBy=multi-user.target" >/lib/systemd/system/nginx.service
        systemctl daemon-reload
        systemctl start nginx
        systemctl enable nginx
        echo -e "${Green}done!${Font}"
	        
	fi
}

wgettcp() {
	echo -e "${YELLOW}正在配置nginx环境文件${PLAIN}"
			sleep 5
            rm -rf /usr/local/nginx/cert
            mkdir /usr/local/nginx/cert
            cd /usr/local/nginx/cert
			wget --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test6/cert/open.pem
            wget --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test6/cert/open.key
            wget --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test6/cert/tj443.pem
            wget --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test6/cert/tj443.key
            wget --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test6/cert/yptj.pem
            wget --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test6/cert/yptj.key
            rm -rf /usr/local/nginx/tcp
            mkdir /usr/local/nginx/tcp
            cd /usr/local/nginx/tcp
            cd /usr/local/nginx/tcp
            wget --no-check-certificate https://ghproxy.com/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test6/tcp/lbtj.conf

            systemctl reload nginx
			clear
};

last(){
    echo "———————————————————番茄V2 Trojan配置一键脚本———————————————————————"
    echo "       适用系统：CentOS 7.X"
	echo "       脚本更新: 2023/03/14"
	echo "       作者：饭桶LemonTea"
	echo -e "       ${RED}一键脚本只为懒人方便，强烈建议您手动操作进行配置${PLAIN}"
	echo "——————————————————————————————————————————————————————————————————"
}



runall() {
	checkroot;
	preinfo;
	checkwget;
	checknginx;
    wgettcp;
	last
}

runall