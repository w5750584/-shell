#!/bin/bash
url=1
xml_file=/tmp/apps
app_list_file=/tmp/app_list.txt
ip=$(ifconfig -a | awk '{print $2}' | sed -n 2p)
#请修改
#eureka_url=http://xxx/eureka/apps
eureka_url=http://$ip:18761/eureka/apps
app_list_url=http://10.125.4.9/script/app_list.txt
#
wget -q $app_list_url -O $app_list_file
if [ $? != 0 ];then
	exit $?
fi
wget -q $eureka_url -O $xml_file 
if [ $? != 0 ];then
        exit $?
fi
unicode_xml(){
e_svc_num=`echo  "cat /" |  xmllint --shell $xml_file | grep "<application>" | wc -l`
for i in `seq 1 ${e_svc_num}`;do
	ips=""
	name=`echo "cat /applications/application[$i]/name"  | xmllint --shell $xml_file  | sed "/^\/ >/d" | sed "s/<[^>]*.//g"`
	e_app_num=`echo  "cat /applications/application[$i]" |  xmllint --shell $xml_file  | grep "<instance>" | wc -l`
	for ii in `seq 1 ${e_app_num}`;do
	ip=`echo "cat /applications/application[$i]/instance[$ii]/ipAddr"  | xmllint --shell $xml_file  | sed "/^\/ >/d" | sed "s/<[^>]*.//g"`
	port=`echo "cat /applications/application[$i]/instance[$ii]/port"  | xmllint --shell $xml_file  | sed "/^\/ >/d" | sed "s/<[^>]*.//g"`
	statu=`echo "cat /applications/application[$i]/instance[$ii]/status"  | xmllint --shell $xml_file  | sed "/^\/ >/d" | sed "s/<[^>]*.//g"`
	if [ "$ips" != "" ];then
		ips="$ips-$ip:$port:$statu"
	else
		ips=$ip:$port:$statu
	fi
	done
	echo $name,$ips
done
}
#alert(){
#s=`unicode_xml`
#cat $app_list_file | while read line;do
#	app_name=`echo $line | awk  '{print $1}'`
#	list_num=`echo $line | awk  '{print $2}'`
#	tmp=`echo $s | grep -v grep | grep $app_name`
#	if [ $? -ne 0 ];then
#		echo "$app_name 3"
#		exit 3
#	fi
#	for i in ${s[@]};do
#		app_ip=`echo $i | awk -F ',' '{print $NF}'`
#		app_ip=`echo $app_ip | sed 's/-/\ /g'`
#		x=0
#		for ii in ${app_ip[@]};do
#			let x=$x+1	
#		done
#		if [ $x -lt $list_num ];then
#			echo "$app_name 2"
#			exit 2
#		fi 
#	done
#done
#}
alert(){
	all_svc=`unicode_xml`
	svc_list=`echo "$all_svc" | grep $1","`
	status_list=`echo $svc_list | awk -F ',' '{print $NF}'`
        i=0
        status_list=`echo $status_list | sed 's/-/\ /g'`
        for x in ${status_list[@]};do
		tmp_up_status=`echo $x | grep "UP"`
		if [ $? -eq 0 ];then
			let i=$i+1
		else
			i=$i
		fi
        done
	s_app_num=`cat $app_list_file | grep "$1 " | awk '{print $NF}'`
	if [ $i -lt $s_app_num ];then
		echo 0
		exit 1
	else
		echo 1
		exit 0
	fi	
}
zabbix_discovery_map(){
	js='{"data":['
	while read line;do
		app_name=`echo $line | awk '{print $1}'`
		js=$js'{"{#JAR_NAME}":"'$app_name'"},'
	done < $app_list_file
	js=$js']}'
	echo $js | sed 's/,]/]/g'
}
get_svc_num(){
	all_svc=`unicode_xml`
	svc_list=`echo "$all_svc" | grep $1","`
	status_list=`echo $svc_list | awk -F ',' '{print $NF}'`
	i=0
	status_list=`echo $status_list | sed 's/-/\ /g'`
	for x in ${status_list[@]};do
                tmp_up_status=`echo $x | grep "UP"`
                if [ $? -eq 0 ];then
                        let i=$i+1
                else
                        i=$i
                fi
	done
	echo $i
		
}
$1 $2

#rm ${app_list_file} -f
#rm ${xml_file} -f
#zabbix_discovery_map
