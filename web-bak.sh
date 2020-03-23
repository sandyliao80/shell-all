#!/bin/bash
#你要修改的地方从这里开始
WEB_DATA=/home/wwwroot          #要备份的网站数据，如果是使用lnmp安装包，则默认这个为网站目录
#你要修改的地方从这里结束
service_name=website服务器 #支持中文
service_ip=10.10.10.10 #请不要使用&¥等特殊符号
server_key=123456789 #server酱申请key http://sc.ftqq.com/

#记录开始时间
start=`date +%Y-%m-%d_%H:%M:%S`
echo -e "开始执行备份：$start" >> $WEB_DATA/auto_backup.log

#定义web数据的名字和web数据的名字
WebBakName=Web_$service_name_$(date +%Y%m%d).tar.gz
OldWeb=Web_$service_name_$(date -d -1day +"%Y%m%d").tar.gz

echo "删除1天前的数据"
#rm -rf /root/webbak/Web_$(date -d -1day +"%Y%m%d").tar.gz
find /root/webbak  -mtime +1 -type f -name 'Web_*.gz' |xargs rm -rf
echo "进入本地目录"
cd /root/webbak

#压缩网站数据
tar zcf /root/webbak/$WebBakName $WEB_DATA

echo “web备份结束”

#记录结束时间
end=`date +%Y-%m-%d_%H:%M:%S`
echo -e "结束执行备份：$end\n" >> $WEB_DATA/auto_backup.log

#发送方糖通知
curl -d "text=
web数据库备份完成
&desp=
 web($service_ip)数据备份完成！
 $service_name
 开始时间：$start ---> 完成时间：$end" https://sc.ftqq.com/$server_key.send
