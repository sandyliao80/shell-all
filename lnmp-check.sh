#!/bin/bash
#设置服务器
service_name=lnmp服务器 #支持中文
service_ip=10.10.10.10 #请不要使用&¥等特殊符号
server_key=123456789 #server酱申请key http://sc.ftqq.com/
url=https://username.com/nginx.php #监控https状态
###获取当前时间
time="$(date +"%Y%m%d-%H:%M")"
###查看fpm服务是否运行
i=`netstat -an | grep php-cgi | wc -l`
if [ $i = 0 ]
        then
               ###重启php服务
               /etc/init.d/php-fpm restart
               ### 写入日志 
               echo "$time php-fpm service is down .... restart..." >> /var/log/php-fpm.log
               #发送方糖通知
               echo "weixin 推送"
               curl -d "text=web服务($service_ip)重启一次&desp= web服务($service_name $service_ip)出现故障重启一次！" https://sc.ftqq.com/$server_key.send
fi
###查看mysql服务是否运行
i=`netstat -anpt | grep mysqld | awk '{print $4}' | awk -F: '{print $2}' | wc -l`
if [ $i = 0 ]
        then
               ### 重启mysql服务
               /etc/init.d/mysql restart
               ### 写入日志
               echo "$time mysqld service is down .... restart..." >> /var/log/mysql-error.log
               #发送方糖通知
               echo "weixin 推送"
               curl -d "text=mysql服务($service_ip)重启一次&desp= mysql服务($service_name $service_ip)出现故障重启一次！" https://sc.ftqq.com/$server_key.send
fi
###查看nginx服务是否运行
i=`netstat -anpt | grep nginx | awk '{print $4}' | awk -F: '{print $2}' | wc -l`
if [ $i = 0 ]
        then
               ### 重启nginx服务
               /etc/init.d/nginx restart
               ### 写入日志
               echo "$time nginx service is down .... restart..." >> /var/log/nginx-error.log
               #发送方糖通知
               echo "weixin 推送"
               curl -d "text=Nginx服务($service_ip)重启一次&desp= Nginx服务($service_name $service_ip)出现故障重启一次！" https://sc.ftqq.com/$server_key.send
fi

## 判断状态码是否为200
i=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $url)
if [ $i -ne 200 ]; then
                 /etc/init.d/mysql restart
                 /etc/init.d/nginx restart
                 /etc/init.d/php-fpm restart
                 echo " $time 监测页: $url 状态码: $i 行为: 异常&重启" >> /var/log/httpcode.log
                 #发送方糖通知
                 echo "weixin 推送"
                 curl -d "text=http服务($url)异常&desp= $time 监测页: $url 状态码: $i 行为: 异常&重启!" https://sc.ftqq.com/$server_key.send
fi
