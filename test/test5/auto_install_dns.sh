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
echo "
${dns_ips}:
  strategy: ipv4_first
  rules:
   - domain:#NETFLIX
   - domain:fast.com
   - domain:netflix.ca
   - domain:netflix.com
   - domain:netflix.net
   - domain:netflixinvestor.com
   - domain:netflixtechblog.com
   - domain:nflxext.com
   - domain:nflximg.com
   - domain:nflximg.net
   - domain:nflxsearch.net
   - domain:nflxso.net
   - domain:nflxvideo.net
   - domain:#DISNEY
   - domain:disneyplus.com
   - domain:disney-plus.net
   - domain:disneystreaming.com
   - domain:dssott.com
   - domain:bamgrid.com
   - domain:playback-certs.bamgrid.com
   - domain:disney.api.edge.bamgrid.com
   - domain:disney.connections.edge.bamgrid.com
   - domain:disney.content.edge.bamgrid.com
   - domain:disney.playback.edge.bamgrid.com
   - domain:cdn.registerdisney.go.com
   - domain:execute-api.us-east-1.amazonaws.com
   - domain:sanalytics.disnyplus.com
   - domain:#BAHAMUT
   - domain:gamer.com.tw
   - domain:bahamut.com.tw
   - domain:hinet.net
   - domain:fbcdn.net
   - domain:gvt1.com
   - domain:digicert.com
   - domain:viblast.com
   - domain:#HBOGOMAX
   - domain:conviva.com
   - domain:go.com
   - domain:hbo.com
   - domain:hbogo.com
   - domain:hbonow.com
   - domain:hboasia.com
   - domain:hbogoasia.hk
   - domain:hbogoasia.com
   - domain:amazonaws.com
   - domain:akamaihd.net
   - domain:boltdns.net
   - domain:cinemax.com
   - domain:comhbo.com
   - domain:hbomax.com
   - domain:maxgo.com
   - domain:#DAZN
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
   - domain:#TVB
   - domain:bigbigchannel.com.hk
   - domain:bigbigshop.com
   - domain:content.jwplatform.com
   - domain:encoretvb.com
   - domain:mytvsuper.com
   - domain:mytvsuperlimited.hb.omtrdc.net
   - domain:mytvsuperlimited.sc.omtrdc.net
   - domain:tvb.com
   - domain:tvb.com.au
   - domain:tvbanywhere.com
   - domain:tvbanywhere.com.sg
   - domain:tvbc.com.cn
   - domain:tvbeventpower.com.hk
   - domain:tvbusa.com
   - domain:tvbweekly.com
   - domain:tvmedia.net.au
   - domain:videos-f.jwpsrv.com
   - domain:#DMM
   - domain:dmm.com
   - domain:dmm.co.jp
   - domain:dmm-extension.com
   - domain:dmmapis.com
   - domain:api-p.videomarket.jp
   - domain:videomarket.jp
   - domain:p-smith.com
   - domain:vmdash-cenc.akamaized.net
   - domain:img.vm-movie.jp
   - domain:bam.nr-data.net
   - domain:api-p.videomarket.jp
   - domain:#NOWE
   - domain:nowe.com
   - domain:nowestatic.com
   - domain:#BILIBILI
   - domain:akamaized.net
   - domain:acg.tv
   - domain:acgvideo.com
   - domain:b23.tv
   - domain:bigfun.cn
   - domain:biliapi.com
   - domain:biliapi.net
   - domain:bilibili.com
   - domain:bilibili.tv
   - domain:bilibiligame.net
   - domain:bilicdn1.com
   - domain:bilicdn2.com
   - domain:bilicdn3.com
   - domain:bilicdn4.com
   - domain:bilicdn5.com
   - domain:biligame.com
   - domain:biligame.net
   - domain:bilivideo.com
   - domain:bilivideo.cn
   - domain:hdslb.com
   - domain:im9.com
   - domain:mincdn.com
   - domain:biligo.com
   - domain:#CATCHPLAY
   - domain:catchplay.com.tw
   - domain:catchplay.com
   - domain:cloudfront.net
   - domain:akamaized.net
   - domain:#KKTV
   - domain:kktv.com.tw
   - domain:kktv.me
   - domain:kk.stream
   - domain:#MYVIDEO
   - domain:myvideo.net.tw
   - domain:#LINETV
   - domain:chocotv.com.tw
   - domain:line-cdn.net
   - domain:line-scdn.net
   - domain:linetv.tw
   - domain:#LITV
   - domain:litv.tv
   - domain:4gtv.tv
   - domain:#HAMIVIDEO
   - domain:apl-hamivideo.cdn.hinet.net
   - domain:banner-cfnetwork.cdn.hinet.net
   - domain:hamivideo.hinet.net
   - domain:previewvod-hamivideo.cdn.hinet.net
   - domain:#VIUTV
   - domain:viu.tv
   - domain:viu.com
   - domain:viu.now.com
   - domain:nowe.com
   - domain:gvt1.com
   - domain:gvt2.com
   - domain:gvt3.com
   - domain:amazonaws.com
   - domain:firebaseio.com
   - domain:jwplayer.com
   - domain:cloudfront.net
   - domain:#ABEMA
   - domain:abema.io
   - domain:abema.tv
   - domain:ds-linear-abematv.akamaized.net
   - domain:linear-abematv.akamaized.net
   - domain:ds-vod-abematv.akamaized.net
   - domain:vod-abematv.akamaized.net
   - domain:ameba.jp
   - domain:hayabusa.io
   - domain:mobile-collector.newrelic.com
   - domain:vod-abematv.akamaized.net
   - domain:bucketeer.jp
   - domain:abema.adx.promo
   - domain:hayabusa.media
   - domain:#NICONICO
   - domain:dmc.nico
   - domain:nicovideo.jp
   - domain:nimg.jp
   - domain:socdm.com
   - domain:#TELASA
   - domain:telasa.jp
   - domain:kddi-video.com
   - domain:videopass.jp
   - domain:d2lmsumy47c8as.cloudfront.net
   - domain:#PARAVI
   - domain:paravi.jp
   - domain:unext.jp
   - domain:nxtv.jp
   - domain:#HULUJP
   - domain:hulu.com
   - domain:huluad.com
   - domain:huluim.com
   - domain:hulustream.com
   - domain:happyon.jp
   - domain:hulu.jp
   - domain:hjholdings.jp
   - domain:streaks.jp
   - domain:yb.uncn.jp
   - domain:hulu.hb.omtrdc.net
   - domain:conviva.com
   - domain:imrworldwide.com
   - domain:tealiumiq.com
   - domain:tiqcdn.com
   - domain:microad.jp
   - domain:adsrvr.org
   - domain:adsmoloco.com
   - domain:yimg.jp
   - domain:webantenna.info
   - domain:doubleclick.net
   - domain:usergram.info
   - domain:hjholdings.tv
   - domain:#TVER
   - domain:tver.jp
   - domain:edge.api.brightcove.com
   - domain:players.brightcove.net
   - domain:#WOWOW
   - domain:wowow.co.jp
   - domain:#FUJITV
   - domain:fujitv.co.jp
   - domain:stream.ne.jp
   - domain:#RADIKO
   - domain:radiko.jp
   - domain:radionikkei.jp
   - domain:smartstream.ne.jp
   - domain:#KARAOKE
   - domain:clubdam.com
   - domain:#GAMES
   - domain:cygames.jp
   - domain:konosubafd.jp
   - domain:colorfulpalette.org
   - domain:cds1.clubdam.com
   - domain:api.worldflipper.jp
   - domain:#MUSICJP
   - domain:music-book.jp
   - domain:overseaauth.music-book.jp
   - domain:#GYAO!
   - domain:gyao.yahoo.co.jp
   - domain:#J:COM
   - domain:id.zaq.ne.jp
   - domain:elevensports.com
   - domain:starplus.com
   - domain:directvgo.com
   - domain:funimation.com
   - domain:starott.com
   - domain:star.api.edge.bamgrid.com
   - domain:star.connections.edge.bamgrid.com
   - domain:star.content.edge.bamgrid.com
   - domain:star.playback.edge.bamgrid.com
   - domain:hotstar.com
   - domain:dtci.co
   - domain:dtci.technologydtci.technology
   - domain:espn.co.ukespn.co.uk
   - domain:espn.comespn.com
   - domain:espn.netespn.net
   - domain:espncdn.comespncdn.com
   - domain:espnqa.comespnqa.com
   - domain:watchespn.comwatchespn.com
   - domain:espn.hb.omtrdc.net
   - domain:espndotcom.tt.omtrdc.net
   - domain:espn.api.edge.bamgrid.com
   - domain:starz.com
   - domain:auth.starz.com
   - domain:fubo.tv
   - domain:dishworld.com
   - domain:slinginternational.com
   - domain:sling.com
   - domain:movenetworks.com
   - domain:movetv.com
   - domain:content-ause1-ur-discovery1.uplynk.com
   - domain:disco-api.com
   - domain:discoveryplus.com
   - domain:paramountplus.com
   - domain:peacocktv.com
   - domain:atttvnow.com
   - domain:setantasports.com
   - domain:encoretvb.com
   - domain:#FOX
   - domain:fox-corporation.com
   - domain:fox-news.com
   - domain:fox.com
   - domain:fox.tv
   - domain:fox10.tv
   - domain:fox10news.com
   - domain:fox10phoenix.com
   - domain:fox11.com
   - domain:fox13memphis.com
   - domain:fox13news.com
   - domain:fox23.com
   - domain:fox23maine.com
   - domain:fox247.com
   - domain:fox247.tv
   - domain:fox26.com
   - domain:fox26houston.com
   - domain:fox28media.com
   - domain:fox29.com
   - domain:fox2detroit.com
   - domain:fox2news.com
   - domain:fox32.com
   - domain:fox32chicago.com
   - domain:fox35orlando.com
   - domain:fox38corpuschristi.com
   - domain:fox42kptm.com
   - domain:fox46.com
   - domain:fox46charlotte.com
   - domain:fox47.com
   - domain:fox49.tv
   - domain:fox4news.com
   - domain:fox51tns.net
   - domain:fox5atlanta.com
   - domain:fox5dc.com
   - domain:fox5ny.com
   - domain:fox5storm.com
   - domain:fox6now.com
   - domain:fox7.com
   - domain:fox7austin.com
   - domain:fox9.com
   - domain:foxacrossamerica.com
   - domain:foxaffiliateportal.com
   - domain:foxandfriends.com
   - domain:foxbet.com
   - domain:foxbusiness.com
   - domain:foxbusiness.tv
   - domain:foxbusinessgo.com
   - domain:foxcanvasroom.com
   - domain:foxcareers.com
   - domain:foxcharlotte.com
   - domain:foxcincy.com
   - domain:foxcincy.jobs
   - domain:foxcincy.net
   - domain:foxcollegesports.com
   - domain:foxcorporation.com
   - domain:foxcreativeuniversity.com
   - domain:foxcredit.com
   - domain:foxcredit.org
   - domain:foxd.tv
   - domain:foxdcg.com
   - domain:foxdeportes.com
   - domain:foxdeportes.net
   - domain:foxdeportes.tv
   - domain:foxdigitalmovies.com
   - domain:foxdoua.com
   - domain:foxentertainment.com
   - domain:foxest.com
   - domain:foxfaq.com
   - domain:foxfdm.com
   - domain:foxfiles.com
   - domain:foxinc.com
   - domain:foxkansas.com
   - domain:foxla.com
   - domain:foxla.tv
   - domain:foxlexington.com
   - domain:foxmediacloud.com
   - domain:foxnation.com
   - domain:foxnebraska.com
   - domain:foxneo.com
   - domain:foxneodigital.com
   - domain:foxnetworks.info
   - domain:foxnetworksinfo.com
   - domain:foxnews.cc
   - domain:foxnews.com
   - domain:foxnews.net
   - domain:foxnews.org
   - domain:foxnews.tv
   - domain:foxnewsaffiliates.com
   - domain:foxnewsaroundtheworld.com
   - domain:foxnewsb2b.com
   - domain:foxnewschannel.com
   - domain:foxnewsgo.net
   - domain:foxnewsgo.org
   - domain:foxnewsgo.tv
   - domain:foxnewshealth.com
   - domain:foxnewslatino.com
   - domain:foxnewsmagazine.com
   - domain:foxnewsnetwork.com
   - domain:foxnewsopinion.com
   - domain:foxnewspodcasts.com
   - domain:foxnewspolitics.com
   - domain:foxnewsradio.com
   - domain:foxnewsrundown.com
   - domain:foxnewssunday.com
   - domain:foxon.com
   - domain:foxphiladelphia.com
   - domain:foxplus.com
   - domain:foxpoker.com
   - domain:foxrad.io
   - domain:foxredeem.com
   - domain:foxrelease.com
   - domain:foxrichmond.com
   - domain:foxrobots.com
   - domain:foxsmallbusinesscenter.com
   - domain:foxsmallbusinesscenter.net
   - domain:foxsmallbusinesscenter.org
   - domain:foxsoccer.net
   - domain:foxsoccer.tv
   - domain:foxsoccermatchpass.com
   - domain:foxsoccerplus.com
   - domain:foxsoccerplus.net
   - domain:foxsoccerplus.tv
   - domain:foxsoccershop.com
   - domain:foxsports-chicago.com
   - domain:foxsports-newyork.com
   - domain:foxsports-world.com
   - domain:foxsports.cl
   - domain:foxsports.co
   - domain:foxsports.co.ve
   - domain:foxsports.com
   - domain:foxsports.com.ar
   - domain:foxsports.com.bo
   - domain:foxsports.com.br
   - domain:foxsports.com.co
   - domain:foxsports.com.ec
   - domain:foxsports.com.gt
   - domain:foxsports.com.mx
   - domain:foxsports.com.pe
   - domain:foxsports.com.py
   - domain:foxsports.com.uy
   - domain:foxsports.com.ve
   - domain:foxsports.gt
   - domain:foxsports.info
   - domain:foxsports.net
   - domain:foxsports.net.br
   - domain:foxsports.pe
   - domain:foxsports.sv
   - domain:foxsports.uy
   - domain:foxsports2.com
   - domain:foxsportsflorida.com
   - domain:foxsportsgo.com
   - domain:foxsportsla.com
   - domain:foxsportsnetmilwaukee.com
   - domain:foxsportsneworleans.com
   - domain:foxsportsracing.com
   - domain:foxsportssupports.com
   - domain:foxsportsuniversity.com
   - domain:foxsportsworld.com
   - domain:foxstudiolot.com
   - domain:foxsuper6.com
   - domain:foxtel.com
   - domain:foxtel.com.au
   - domain:foxtelevisionstations.com
   - domain:foxtv.com
   - domain:foxtvdvd.com
   - domain:foxuv.com
   - domain:foxweatherwatch.com
   - domain:fssta.com
   - domain:fxn.ws
   - domain:fxnetwork.com
   - domain:fxnetworks.com
   - domain:bentobox.tv
   - domain:kicu.tv
   - domain:ktvu.com
   - domain:myfoxsanfran.com
   - domain:afewmomentswith.com
   - domain:anidom.com
   - domain:casoneexchange.com
   - domain:coronavirusnow.com
   - domain:fse.tv
   - domain:geraldoatlarge.com
   - domain:gooddaychicago.com
   - domain:joeswall.com
   - domain:kilmeadeandfriends.com
   - domain:maskedsingerfox.com
   - domain:my13la.com
   - domain:my20dc.com
   - domain:my20houston.com
   - domain:my29tv.com
   - domain:my45.com
   - domain:my9nj.com
   - domain:myfoxatlanta.com
   - domain:myfoxaustin.com
   - domain:myfoxboston.com
   - domain:myfoxcharlotte.com
   - domain:myfoxchicago.com
   - domain:myfoxdc.com
   - domain:myfoxdetroit.com
   - domain:myfoxdfw.com
   - domain:myfoxhouston.com
   - domain:myfoxhurricane.com
   - domain:myfoxla.com
   - domain:myfoxlosangeles.com
   - domain:myfoxlubbock.com
   - domain:myfoxmaine.com
   - domain:myfoxny.com
   - domain:myfoxorlando.com
   - domain:myfoxphilly.com
   - domain:myfoxphoenix.com
   - domain:myfoxtampa.com
   - domain:myfoxtampabay.com
   - domain:myfoxtwincities.com
   - domain:myfoxzone.com
   - domain:myq2.com
   - domain:newsnowfox.com
   - domain:orlandohurricane.com
   - domain:paradisehotelquizfox.com
   - domain:q13.com
   - domain:q13fox.com
   - domain:realamericanstories.com
   - domain:realamericanstories.info
   - domain:realamericanstories.net
   - domain:realamericanstories.org
   - domain:realamericanstories.tv
   - domain:realmilwaukeenow.com
   - domain:rprimelab.com
   - domain:shopspeedtv.com
   - domain:soccermatchpass.com
   - domain:speeddreamride.com
   - domain:speedfantasybid.com
   - domain:speedracegear.com
   - domain:speedxtra.com
   - domain:teenchoice.com
   - domain:testonfox.com
   - domain:theclasshroom.com
   - domain:thefoxnation.com
   - domain:thegeorgiascene.com
   - domain:whatthefox.com
   - domain:whosthehost.com
   - domain:wofl.tv
   - domain:woflthenewsstation.com
   - domain:wogx.com
   - domain:x-live-fox-stgec.uplynk.com
   - domain:prd-storage-game-umamusume.akamaized.net
   - domain:prd-storage-app-umamusume.akamaized.net
   - domain:#SPOTIFY
   - domain:byspotify.com
   - domain:pscdn.co
   - domain:scdn.co
   - domain:spoti.fi
   - domain:spotify-everywhere.com
   - domain:spotify.com
   - domain:spotify.design
   - domain:spotifycdn.com
   - domain:spotifycdn.net
   - domain:spotifycharts.com
   - domain:spotifycodes.com
   - domain:spotifyforbrands.com
   - domain:spotifyjobs.com
   - domain:audio-ak-spotify-com.akamaized.net
   - domain:heads4-ak-spotify-com.akamaized.net
   - domain:spclient.wg.spotify.com
   - domain:#IQIYI
   - domain:71.am
   - domain:iq.com
   - domain:iqiyi.com
   - domain:iqiyipic.com
   - domain:pps.tv
   - domain:ppsimg.com
   - domain:qiyi.com
   - domain:qiyipic.com
   - domain:qy.net
   - domain:#TIKTOK
   - domain:byteoversea.com
   - domain:muscdn.com
   - domain:musical.ly
   - domain:tik-tokapi.com
   - domain:tiktok.com
   - domain:tiktokcdn.com
   - domain:tiktokv.com
   - domain:p16-tiktokcdn-com.akamaized.net
   - domain:bbc.co.uk
   - domain:bbc.com
   - domain:bbc.in
   - domain:bbc.net.uk
   - domain:bbci.co.uk
   - domain:bbcfmt.s.llnwi.net
   - domain:bbcmedia.co.uk
   - domain:bbcpersian.com
   - domain:bbcverticals.com
   - domain:bidi.net.uk
   - domain:as-dash-uk-live.akamaized.net
   - domain:as-hls-uk-live.akamaized.net
   - domain:vod-dash-ww-live.akamaized.net
   - domain:vod-thumb-ww-live.akamaized.net
   - domain:vod-dash-uk-live.akamaized.net
   - domain:vod-thumb-uk-live.akamaized.net
   - domain:vod-hls-uk-live.akamaized.net
   - domain:vod-sub-uk-live.akamaized.net
   - domain:vs-cmaf-push-uk-live.akamaized.net
   - domain:channel4.com
   - domain:c4assets.com
   - domain:channel4.sc.omtrdc.net
   - domain:pjsekai.sega.jp
   - domain:britbox.com
   - domain:britbox.co.uk
   - domain:bbc.co.uk
   - domain:bb-static.com
   - domain:massive-itv.com
   - domain:itv.com
   - domain:itvpnp.stage.ott.irdeto.com
   - domain:itvpnp.live.ott.irdeto.com
   - domain:zdf.de
   - domain:zdf-hls-15.akamaized.net
   - domain:platform.openai.com
   - domain:beta.openai.com
   - domain:auth0.openai.com
   - domain:auth1.openai.com
   - domain:auth2.openai.com
   - domain:openai.com
   - domain:chat.openai.com

">/etc/soga/dns.yml
soga restart
docker restart $( docker ps -a -q) 
echo "已成功部署 DNS 解锁配置。"
