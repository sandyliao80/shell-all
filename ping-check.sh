#!/bin/bash
# blog：https://blog.e9china.net

server_key=1234567 #server酱申请key http://sc.ftqq.com/
IP_LIST="192.168.1.2 192.168.1.3 10.10.10.10"
for IP in $IP_LIST; do
    FAIL_COUNT=0
    for ((i=1;i<=3;i++)); do
        if ping -c 1 $IP >/dev/null; then
            echo "$IP Ping is successful."
            break
        else
            # echo "$IP Ping is failure $i"
            let FAIL_COUNT++
        fi
    done
    if [ $FAIL_COUNT -eq 3 ]; then
        echo "$IP Ping is failure!"
        curl -d "text=$IP Ping失败&desp=尝试对 $IP ping但是不通,主人快来解决！" https://sc.ftqq.com/$server_key.send
    fi
done
