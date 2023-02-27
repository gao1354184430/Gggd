#!/bin/bash
#远端文件储存地址
Github="https://ghproxy.net/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test6"
Github_shell="https://ghproxy.net/https://raw.githubusercontent.com/gao1354184430/Gggd/master/test/test5"
#测试与GitHub连通性
rm -rf /root/.test.txt
curl -s $Github/test > /root/.test.txt
github_test=`sed -n '1p' /root/.test.txt`
rm -rf /root/.test.txt /root/.crontab.txt
#颜色文字
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
#开始
function patch_localhost() {
localhost_ip=`curl ip.sb`
sed -i '/localhost/d' /etc/hosts
		echo "127.0.0.1   localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost.localdomain localhost6 localhost6.localdomain6
$localhost_ip   localhost" >/etc/hosts
echo -e "${Info}如果下面输出内容为空或者IP地址为空，请检查"
cat /etc/hosts
}
function down80_443() {
iptables -A INPUT -p tcp --dport 80 -j DROP
iptables -A INPUT -p udp --dport 80 -j DROP
iptables -A INPUT -p tcp --dport 443 -j DROP
iptables -A INPUT -p udp --dport 443 -j DROP
service iptables save
}
function rm_logs() {
rm -rf /var/log/cron-*
rm -rf /var/log/maillog-*
rm -rf /var/log/messages-*
rm -rf /var/log/secure-*
rm -rf /var/log/spooler-*
rm -rf /var/log/boot.log-*
rm -rf /var/log/btmp-*
rm -rf /var/log/auth.log.*
rm -rf /var/log/daemon.log.*
rm -rf /var/log/syslog.*
echo > /var/log/auth.log
echo > /var/log/daemon.log
echo > /var/log/syslog
echo > /var/log/messages
echo > /usr/local/nginx/logs/access.log
echo > /usr/local/nginx/logs/error.log
echo -e "${Info}日志清理完成"
}
function crontab_add_patch(){
    #创建监控文件
	mkdir /usr/local/cron
	echo "#!/bin/bash
#
/root/patch.sh logs
">/usr/local/cron/patch_cron
	#查看是否已经存在监控
	cron_config=$(crontab -l | grep "patch_cron")
	#检查并添加自动同步
    if [[ -z ${cron_config} ]]; then
		rm -r "/root/crontab.bak"
		crontab -l > "/root/crontab.bak"
		echo -e "\n0 4 * * * bash /usr/local/cron/patch_cron" >> "/root/crontab.bak"
		crontab "/root/crontab.bak"
		rm -r "/root/crontab.bak"
        echo -e "${Info} 已添加 patch_cron 自动同步!"        
    else
		echo -e "${Error} patch_cron 自动同步已存在" 
    fi
}
#cn菜单
function menu_server() {
  echo && echo -e "  替一些软件打补丁，软件犯的错交给系统解决
  其中选项1适用于本地回环出现问题的情况，比如该死的移动机器
 ————————————
 ${Green_font_prefix} 1:${Font_color_suffix} localhost指定至本机IP
 ${Green_font_prefix} 2:${Font_color_suffix} 屏蔽80/443端口
 ${Green_font_prefix} 3:${Font_color_suffix} 一键清理N个日志
————————————" &&echo 
  echo
  read -erp " 请输入对应的数字:" Num
  case "$Num" in
  1)
    patch_localhost
    ;;
  2)
    down80_443
    ;;
  3)
    rm_logs
    ;;
  *)
    echo "请输入正确数字 [1-3]"
    ;;
  esac
}
action=$1
if [[ -n $action ]]; then
#增加一个通信检测，如果与GitHub通信失败则停止脚本
	if [[ $github_test == "success" ]]; then
		if [[ $action == "logs" ]]; then
			rm_logs		
        elif [[ $action == "addcron" ]]; then
            crontab_add_patch		
		fi
	else
		echo -e "\033[31m 远端通信失败，程序中止 \033[0m"
	fi
else
	menu_server
fi
