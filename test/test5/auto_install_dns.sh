#!/bin/bash

# 检测发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    os=$ID
else
    echo "无法检测到发行版。"
    exit 1
fi

# 安装 jq（如果尚未安装）
if ! [ -x "$(command -v jq)" ]; then
  echo "安装 jq ..."

  if [ "$os" = "centos" ]; then
    sudo yum -y install epel-release
    sudo yum -y install jq
  elif [ "$os" = "debian" ]; then
    sudo apt-get update
    sudo apt-get install -y jq
  else
    echo "不支持的发行版。"
    exit 1
  fi
fi

# 获取 VPS 的公共 IP 地址
public_ip=$(curl -s ifconfig.me)

# 查询 IP 地址的地理位置信息
ip_info=$(curl -s "https://ipinfo.io/${public_ip}?token=40843e41fc69e0" | jq)

# 提取国家代码
country_code=$(echo $ip_info | jq -r '.country')

# 显示 IP 地址和国家代码信息
echo "检测到 VPS 的 IP 地址为：${public_ip}"
echo "检测到 VPS 所在的国家代码：${country_code}"

# 如果检测出的地区不对，请输入正确的地区代码
read -p "如果地区代码不正确，请输入正确的地区代码（否则按回车键）：" manual_country_code
if [ ! -z "$manual_country_code" ]; then
  country_code=$manual_country_code
fi

# 根据国家代码生成 DNS 解锁配置
case "$country_code" in
  "SG"|"KR"|"JP"|"HK"|"US"|"UK"|"DE"|"TW")
    geosite=" - geosite:netflix
     - geosite:disney
     - geosite:youtube"
    if [ "$country_code" = "UK" ]; then
      geosite="${geosite}"
      general_rules="
  143.47.225.58:
  strategy: ipv4_first
  rules:
    - geosite:bbc
  178.128.212.56,157.230.242.187,178.128.223.178,20.2.249.123:
  strategy: ipv4_first
  rules:
    - geosite:bilibili
    "
    fi
    if [ "$country_code" = "US" ]; then
      general_rules="
  178.128.212.56,157.230.242.187,178.128.223.178,20.2.249.123:
  strategy: ipv4_first
  rules:
    - geosite:bilibili"
    fi
    if [ "$country_code" = "TW" ]; then
      general_rules="
  54.185.77.141,3.144.167.186,34.215.124.151,18.237.220.28:
  strategy: ipv4_first
  rules:
    - geosite:hulu,dazn_us
    - geosite:hbo
    - domain:control.kochava.com
    - domain:d151l6v8er5bdm.cloudfront.net
    - domain:d1sgwhnao7452x.cloudfront.net
    - domain:dazn-api.com
    - domain:dazn.com
    - domain:dazndn.com
    - domain:dc2-vodhls-perform.secure.footprint.net
    - domain:dca-ll-livedazn-dznlivejp.s.llnwi.net
    - domain:dcalivedazn.akamaized.net
    - domain:dcblivedazn.akamaized.net
    - domain:indazn.com
    - domain:indaznlab.com
    - domain:intercom.io
    - domain:logx.optimizely.com
    - domain:s.yimg.jp
    - domain:sentry.io
    - domain:platform.openai.com 
    - domain:beta.openai.com 
    - domain:auth0.openai.com 
    - domain:auth1.openai.com 
    - domain:auth2.openai.com 
    - domain:openai.com 
    - domain:chat.openai.com"
    fi
    if [ "$country_code" = "JP" ]; then
      geosite="${geosite}"
      general_rules="
    - geosite:dazn_jp
    - domain:www.videopass.jp
    - domain:douga.geo-online.co.jp
    - domain:video.tv-tokyo.co.jp
    - domain:www.ytv.co.jp
    - domain:dizm.mbs.jp
    - domain:osaka-channel.hikaritv.net
    - domain:www.tbs.co.jp
    - domain:games.dmm.com
    - domain:konosubafd.jp
    - domain:worldflipper.jp
    - domain:pjsekai.sega.jp
    - domain:www.wowow.co.jp
    - domain:music-book.jp
    - domain:www.videomarket.jp
    - domain:video.unext.jp
    - domain:umamusume.jp
    - domain:nierreincarnation.jp
    - domain:p-eternal.jp
    - domain:erogamescape.dyndns.org
    - domain:radiko.jp
    - domain:www.clubdam.com
    - domain:disneyplus.disney.co.jp
    - domain:vod.skyperfectv.co.jp
    - domain:spoox.skyperfectv.co.jp
    - domain:store.jp.square-enix.com
    - domain:manga.line.me
    - domain:tv.dmm.com
    - domain:tv.dmm.co.jp"
    fi # 将 example.jp 替换为实际的日本域名
    else
      geosite="${geosite}"
      general_rules="
178.128.212.56,157.230.242.187,178.128.223.178,20.2.249.123:
  strategy: ipv4_first
  rules:
    - geosite:bilibili
54.185.77.141,3.144.167.186,34.215.124.151,18.237.220.28:
  strategy: ipv4_first
  rules:
    - geosite:hulu
    - geosite:hbo
    - geosite:dazn_us
    - domain:control.kochava.com
    - domain:d151l6v8er5bdm.cloudfront.net
    - domain:d1sgwhnao7452x.cloudfront.net
    - domain:dazn-api.com
    - domain:dazn.com
    - domain:dazndn.com
    - domain:dc2-vodhls-perform.secure.footprint.net
    - domain:dca-ll-livedazn-dznlivejp.s.llnwi.net
    - domain:dcalivedazn.akamaized.net
    - domain:dcblivedazn.akamaized.net
    - domain:indazn.com
    - domain:indaznlab.com
    - domain:intercom.io
    - domain:logx.optimizely.com
    - domain:s.yimg.jp
    - domain:sentry.io
    - domain:platform.openai.com 
    - domain:beta.openai.com 
    - domain:auth0.openai.com 
    - domain:auth1.openai.com 
    - domain:auth2.openai.com 
    - domain:openai.com 
    - domain:chat.openai.com
143.47.225.58:
  strategy: ipv4_first
  rules:
    - geosite:bbc
      "
    fi
    ;;
  *)
    echo "暂不支持该地区的配置。"
    exit 1
    ;;
esac

# 为不同地区设置不同的 DNS IP
case "$country_code" in
  "SG")
    dns_ips="146.190.200.114,54.179.215.42,159.89.211.38,188.166.196.55,139.59.109.225,139.59.109.242"
    ;;
  "KR")
    dns_ips="144.24.65.233"
    ;;
  "JP")
    dns_ips="172.105.214.160,172.104.97.87,172.105.225.18,172.104.76.30,139.162.86.212"
    ;;
  "HK")
    dns_ips="104.208.65.88,20.187.76.178,20.239.75.33,20.2.83.186"
    ;;
  "US")
    dns_ips="3.144.167.186,54.185.77.141,34.215.124.151,18.237.220.28"
    ;;
  "UK")
    dns_ips="143.47.225.58"
    ;;
  "DE")
    dns_ips="152.70.165.99"
    ;;
  "TW")
    dns_ips="178.128.212.56,157.230.242.187,178.128.223.178,20.2.249.123"
    ;;
  *)
    echo "暂不支持该地区的配置。"
    exit 1
    ;;
esac

# 写入配置文件
echo "${dns_ips}:
  strategy: ipv4_first
  rules:
${geosite}
${general_rules}
">/etc/soga/dns.yml
soga restart
docker restart $( docker ps -a -q) 
echo "已成功部署 DNS 解锁配置。"
