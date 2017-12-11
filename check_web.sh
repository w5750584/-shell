#!/bin/bash
sendemail="/usr/local/bin/sendEmail -f xxx@xxx.com -t xxx.di@xxx.com  -t xxx@139.com -s smtp.ym.163.com:25 -xu xxx@xxx.com -xp xxx"
check_url(){
        if [ "$1" == "help" ] || [ "$1" == "" ];then
                echo "参数1 参数2 参数3"
                echo "URL 页面内容 轮询检测[r](如:check_url http://www.xxx.com "xxx")"
                exit 0
        fi
        curl -s --connect-timeout 2 -m 4 $1 | grep $2
        if [ "$3" == "r" ];then
                curl -s --connect-timeout 2 -m 4 $1 | grep $2
                while [ $? != "0" ];do
                        sleep 1s
                        echo .
                        curl -s --connect-timeout 2 -m 4 $1 | grep $2
                done
                return $?
        else
                curl -s --connect-timeout 4 -m 2 $1 | grep $2
                return $?
        fi
}
nginx_change(){
        case "$1" in
                tbl_76)
                        sed -i 's/127.0.0.1:24080/10.27.0.168:24080/g' /usr/local/nginx1/conf/nginx.conf
                        /usr/local/nginx1/sbin/nginx -s reload;;
                tbl_94)
                        sed -i 's/127.0.0.1:24080/10.132.9.193:24080/g' /usr/local/nginx/conf/nginx.conf
                        /usr/local/nginx/sbin/nginx -s reload;;
                tbl_76_rec)
                        sed -i 's/10.27.0.168:24080/127.0.0.1:24080/g' /usr/local/nginx1/conf/nginx.conf
                        /usr/local/nginx1/sbin/nginx -s reload;;
                tbl_94_rec)
                        sed -i 's/10.132.9.193:24080/127.0.0.1:24080/g' /usr/local/nginx/conf/nginx.conf
                        /usr/local/nginx/sbin/nginx -s reload;;
                *)
                echo "By: Xiaofeng.di@lolaage.com"
                echo " 参数"
                exit 1;;
        esac
        echo $1"负载调整完成"
}
main(){
for ((i=0; i<3; ++i)); do
        check_url "http:/xxx"  "xxx"
        if [ $? -eq 0 ];then
                echo "`date +%F_%T` jy OK" >> /data/sh/log/jy.log
                exit 0
        else
		/usr/local/jdk1.8.0_77/bin/jstack `ps -ef | grep "xxx" | grep -v grep | awk '{print $2}'` >> /data/sh/log/jy_jstack`date +%F_%T`.log
                echo "`date +%F_%T` jy error!" >> /data/sh/log/jy.log
                sleep 5
        fi
        if [ $i -ge 2 ];then
		nginx_change tbl_94
                kill -9 `ps -ef | grep "Dcatalina.home=/data/application/nginx_tomcat/xxx" | awk '{print $2}'`
                sleep 1
                cd /data/application/nginx_tomcat/xxx/bin
                ./startup.sh
                echo "`date +%F_%T` jy restart" >> /data/sh/log/jy.log
                echo "`date +%F_%T` jy restart ok"|$sendemail -u "jy error on aly94" &>/dev/null
		check_url "http://xxx"  "xxx" r
		nginx_change tbl_94_rec
        fi
done
}
main
