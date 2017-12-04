#!/bin/bash
. /etc/profile
. ./includes/inc_config.sh
. ./includes/inc_common.sh
. ./includes/inc_restart.sh
date_name=`date +%Y-%m-%d_%H-%M`
init_ssh #初始化SSH
init_path #初始化配件路径
zl_tbl(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                exit 1
        fi
	mvn tbl
	for i in `cat $tbl_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
		path=`echo $i | awk -F 'webapp' '{print $2}'`
		$ssh_tbl76 "mv $tbl_ro_path/webapps/ROOT/$path $tbl_ro_path/webapps/ROOT/$path-$date_name"
		$ssh_tbl94 "mv $tbl_ro_path/webapps/ROOT/$path $tbl_ro_path/webapps/ROOT/$path-$date_name"
		init_scp $tbl_local_path/target/Webapp/$path $tbl_ro_path/webapps/ROOT/$path
		$scp_tbl76
		$scp_tbl94
		echo "已更新文件"
                $ssh_tbl76 "ls -al $tbl_ro_path/webapps/ROOT/$path"
                $ssh_tbl94 "ls -al $tbl_ro_path/webapps/ROOT/$path"
	done
	if [ $1 == "r" ];then
		nginx_change tbl_76
		service_restart tbl76
                check_url http://your ip:23080/about/app_download2.htm?id=0 "户外助手官方下载"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://your ip:23080/about/app_download2.htm?id=0 "户外助手官方下载"
                done
		nginx_change tbl_76_rec
		nginx_change tbl_94
		service_restart tbl94
                check_url http://your ip:23080/about/app_download2.htm?id=0 "户外助手官方下载"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://your ip:23080/about/app_download2.htm?id=0 "户外助手官方下载"
                done
		nginx_change tbl_94_rec
	fi
}
lg_tcp(){
        mvn lg_tcp
	rm $lgtcp_local_path/target/classes/com.zip
	cd $lgtcp_local_path/target/classes/
	zip -r com.zip com
	#zip -r $lgtcp_local_path/target/classes/com.zip $lgtcp_local_path/target/classes/com/	
	$ssh_lg229 "rm -rf $lgtcp_ro_path/GenericProfessionServer_upgrade/com.zip"
	$ssh_lg108 "rm -rf $lgtcp_ro_path/GenericProfessionServer_upgrade/com.zip"
	init_scp $lgtcp_local_path/target/classes/com.zip $lgtcp_ro_path/GenericProfessionServer_upgrade/com.zip
	$scp_lg229
	$scp_lg108
	$ssh_lg229 "mv $lgtcp_ro_path/GenericProfessionServer_upgrade/com $lgtcp_ro_path/GenericProfessionServer_upgrade/com-$date_name"
	$ssh_lg229 "unzip $lgtcp_ro_path/GenericProfessionServer_upgrade/com.zip -d  $lgtcp_ro_path/GenericProfessionServer_upgrade/"
	$ssh_lg108 "mv $lgtcp_ro_path/GenericProfessionServer_upgrade/com $lgtcp_ro_path/GenericProfessionServer_upgrade/com-$date_name"
	$ssh_lg108 "unzip $lgtcp_ro_path/GenericProfessionServer_upgrade/com.zip -d  $lgtcp_ro_path/GenericProfessionServer_upgrade/"
	service_restart lg229_tcp
	service_restart lg108_tcp
}
ecshop(){
	ln="--------------------"
	cd $ecshop_local_path
	str=`svn info`
	version=`echo "$str" | head -5 | tail -1 | awk '{print $2}'`
	old_version=`cat /data/project/ver.txt`
	echo $ln $ln
	echo "当前svn版本:	"$version
	echo "当前生产版本:	"$old_version
	echo $ln  $ln
	if [ "$version" == "$old_version" ];then
		echo "版本验证通过"
		echo $ln"正在获取最新代码"$ln
		str=`svn up`
		echo "$str"
		int=`echo "$str" | wc -l`
		let int=$int-1
		echo "$str" | head -$int | awk '{print $2}'  | while read line;do
			init_scp $ecshop_local_path/$line $ecshop_ro_path/$line
			$scp_tbl99
			echo "更新文件成功:	"$ecshop_ro_path/$line
		done
		$ssh_tbl99 "/usr/bin/chown -R nobody:nobody $ecshop_ro_path/"
		str=`svn info`
		echo "$str" | head -5 | tail -1 | awk '{print $2}' > /data/project/ver.txt
		echo $ln"更新结束"$ln
	else
		echo "版本验证错误"
		exit 1
	fi
}
fix_ecs_ver(){
	if [ "$1" == "" ];then
		echo "请输入版本号"
	else
		cd /data/project/svn
		svn co "https://svn ip/svn/2bulu/Web/OperationManage/trunk/ecshop/" -r $1
	fi

}
change_store_nginx(){
        case "$1" in
        	store_76)
		$ssh_tbl76 "sed -i 's/http:\/\/store/http:\/\/storebak/g' /usr/local/nginx1/conf/nginx.conf"
		$ssh_tbl94 "sed -i 's/http:\/\/store/http:\/\/storebak/g' /usr/local/nginx/conf/nginx.conf"
		$ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload"
		$ssh_tbl94 "/usr/local/nginx/sbin/nginx -s reload";;
		rec_76)
                $ssh_tbl76 "sed -i 's/http:\/\/storebak/http:\/\/store76/g' /usr/local/nginx1/conf/nginx.conf"
                $ssh_tbl94 "sed -i 's/http:\/\/storebak/http:\/\/store76/g' /usr/local/nginx/conf/nginx.conf"
                $ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload"
                $ssh_tbl94 "/usr/local/nginx/sbin/nginx -s reload";;
		store_rec)
                $ssh_tbl76 "sed -i 's/http:\/\/store76/http:\/\/store/g' /usr/local/nginx1/conf/nginx.conf"
                $ssh_tbl94 "sed -i 's/http:\/\/store76/http:\/\/store/g' /usr/local/nginx/conf/nginx.conf"
                $ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload"
                $ssh_tbl94 "/usr/local/nginx/sbin/nginx -s reload";;
		*)
		echo "test 1111"
		exit 1;;
        esac
        echo $1"负载调整完成"

}
tbl_store_11(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                exit 1
        fi
        mvn tbl_store
        $ssh_tbl76 "cp -r $tbl_store_ro_path/webapps/ROOT $tbl_store_ro_path/webappback/ROOT-$date_name"
        $ssh_tbl94 "cp -r $tbl_store_ro_path/webapps/ROOT $tbl_store_ro_path/webappback/ROOT-$date_name"
        $ssh_tbl99 "cp -r $tbl_store_ro_path/webapps/ROOT $tbl_store_ro_path/webappback/ROOT-$date_name"
        $ssh_tbl67 "cp -r $tbl_store_ro_path/webapps/ROOT $tbl_store_ro_path/webappback/ROOT-$date_name"
        $ssh_tbl193 "cp -r $tbl_store_ro_path/webapps/ROOT $tbl_store_ro_path/webappback/ROOT-$date_name"
	init_scp $tbl_store_local_path/target/Webapp.war $tbl_store_ro_path/webapps/ROOT.war1
	$scp_tbl76
	$ssh_tbl76 "scp -P 50750 $tbl_store_ro_path/webapps/ROOT.war1 10.27.0.168:$tbl_store_ro_path/webapps/ROOT.war1"
	$ssh_tbl76 "scp -P 50750 $tbl_store_ro_path/webapps/ROOT.war1 10.80.226.189:$tbl_store_ro_path/webapps/ROOT.war1"
	$ssh_tbl76 "scp -P 50750 $tbl_store_ro_path/webapps/ROOT.war1 10.241.104.193:$tbl_store_ro_path/webapps/ROOT.war1"
	$ssh_tbl76 "scp -P 50750 $tbl_store_ro_path/webapps/ROOT.war1 10.80.58.27:$tbl_store_ro_path/webapps/ROOT.war1"
	change_store_nginx store_76
        $ssh_tbl76 "rm -rf $tbl_store_ro_path/webapps/ROOT.war"
        $ssh_tbl76 "rm -rf $tbl_store_ro_path/webapps/ROOT"
	$ssh_tbl76 "mv $tbl_store_ro_path/webapps/ROOT.war1 $tbl_store_ro_path/webapps/ROOT.war"
	service_restart store_76
        check_url http://your ip:25081/store/mall.htm "商城"
        while [ $? != "0" ];do
                sleep 1s
                echo .
                check_url http://your ip:25081/store/mall.htm "商城"
        done
        change_store_nginx rec_76
        $ssh_tbl94 "rm -rf $tbl_store_ro_path/webapps/ROOT.war"
        $ssh_tbl94 "rm -rf $tbl_store_ro_path/webapps/ROOT"
        $ssh_tbl99 "rm -rf $tbl_store_ro_path/webapps/ROOT.war"
        $ssh_tbl99 "rm -rf $tbl_store_ro_path/webapps/ROOT"
        $ssh_tbl67 "rm -rf $tbl_store_ro_path/webapps/ROOT.war"
        $ssh_tbl67 "rm -rf $tbl_store_ro_path/webapps/ROOT"
        $ssh_tbl193 "rm -rf $tbl_store_ro_path/webapps/ROOT.war"
        $ssh_tbl193 "rm -rf $tbl_store_ro_path/webapps/ROOT"

	$ssh_tbl94 "mv $tbl_store_ro_path/webapps/ROOT.war1 $tbl_store_ro_path/webapps/ROOT.war"
	$ssh_tbl99 "mv $tbl_store_ro_path/webapps/ROOT.war1 $tbl_store_ro_path/webapps/ROOT.war"
	$ssh_tbl67 "mv $tbl_store_ro_path/webapps/ROOT.war1 $tbl_store_ro_path/webapps/ROOT.war"
	$ssh_tbl193 "mv $tbl_store_ro_path/webapps/ROOT.war1 $tbl_store_ro_path/webapps/ROOT.war"
	service_restart store_94
	service_restart store_99
	service_restart store_67
	service_restart store_193
        check_url http://your ip:25081/store/mall.htm "商城"
        while [ $? != "0" ];do
                sleep 1s
                echo .
                check_url http://your ip:25081/store/mall.htm "商城"
        done
        check_url http://IP:25081/store/mall.htm "商城"
        while [ $? != "0" ];do
                sleep 1s
                echo .
                check_url http://IP:25081/store/mall.htm "商城"
        done
        check_url http://IP:25081/store/mall.htm "商城"
        while [ $? != "0" ];do
                sleep 1s
                echo .
                check_url http://IP:25081/store/mall.htm "商城"
        done
        check_url http://IP:25081/store/mall.htm "商城"
        while [ $? != "0" ];do
                sleep 1s
                echo .
                check_url http://IP:25081/store/mall.htm "商城"
        done
	change_store_nginx store_rec
}
zl_store_11(){
	mvn tblservice
	if [ $? -ne 0 ];then
		echo "tblservice编译失败！"
	fi
	mvn tbl_store
	if [ $? -ne 0 ];then
		echo "tbl_rescue编译失败!"
	fi
	for i in `cat $tbl_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
		path=`echo $i | awk -F 'webapp' '{print $2}'`
		$ssh_tbl76 "mv $tbl_store_ro_path/webapps/ROOT/$path $tbl_store_ro_path/webapps/ROOT/$path-$date_name"
		$ssh_tbl94 "mv $tbl_store_ro_path/webapps/ROOT/$path $tbl_store_ro_path/webapps/ROOT/$path-$date_name"
		$ssh_tbl99 "mv $tbl_store_ro_path/webapps/ROOT/$path $tbl_store_ro_path/webapps/ROOT/$path-$date_name"
		$ssh_tbl67 "mv $tbl_store_ro_path/webapps/ROOT/$path $tbl_store_ro_path/webapps/ROOT/$path-$date_name"
		$ssh_tbl193 "mv $tbl_store_ro_path/webapps/ROOT/$path $tbl_store_ro_path/webapps/ROOT/$path-$date_name"
		init_scp $tbl_store_local_path/target/Webapp/$path $tbl_store_ro_path/webapps/ROOT/$path
		$scp_tbl76
		$scp_tbl94
		$scp_tbl99
		$scp_tbl67
		$scp_tbl193
		echo "已更新文件"
		$ssh_tbl76 "ls -al $tbl_store_ro_path/webapps/ROOT/$path"
	done
	if [ $1 == "r" ];then
		change_store_nginx store_76
		service_restart store_76
		check_url http://your ip:25081/store/mall.htm "商城"
		while [ $? != "0" ];do
			sleep 1s
			echo -n "."
			check_url http://your ip:25081/store/mall.htm "商城"
		done
		change_store_nginx rec_76

		service_restart store_94
		service_restart store_99
		service_restart store_67
		service_restart store_193
		check_url http://your ip:25081/store/mall.htm "商城"
		while [ $? != "0" ];do
			sleep 1s
			echo .
			check_url http://your ip:25081/store/mall.htm "商城"
		done
		check_url http://IP:25081/store/mall.htm "商城"
		while [ $? != "0" ];do
			sleep 1s
			echo .
			check_url http://IP:25081/store/mall.htm "商城"
		done
		check_url http://IP:25081/store/mall.htm "商城"
		while [ $? != "0" ];do
			sleep 1s
			echo .
			check_url http://IP:25081/store/mall.htm "商城"
		done
		check_url http://IP:25081/store/mall.htm "商城"
		while [ $? != "0" ];do
			sleep 1s
			echo .
			check_url http://IP:25081/store/mall.htm "商城"
		done
		change_store_nginx store_rec
	fi
}
tbl_store(){
	mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                exit 1
        fi
	mvn tbl_store
	$ssh_tbl76 "cp -r $tbl_store_ro_path/webapps/ROOT $tbl_store_ro_path/webappback/ROOT-$date_name"
	$ssh_tbl94 "cp -r $tbl_store_ro_path/webapps/ROOT $tbl_store_ro_path/webappback/ROOT-$date_name"
	init_scp $tbl_store_local_path/target/Webapp.war $tbl_store_ro_path/webapps/ROOT.war1
	$scp_tbl76
	$ssh_tbl76 "scp -P 50750 $tbl_store_ro_path/webapps/ROOT.war1 10.27.0.168:$tbl_store_ro_path/webapps/ROOT.war1"
	nginx_change store_76
	$ssh_tbl76 "rm -rf $tbl_store_ro_path/webapps/ROOT.war"
	$ssh_tbl76 "rm -rf $tbl_store_ro_path/webapps/ROOT"
	$ssh_tbl76 "mv $tbl_store_ro_path/webapps/ROOT.war1 $tbl_store_ro_path/webapps/ROOT.war"
	service_restart store_76
	check_url http://your ip:25081/store/mall.htm "商城"
	while [ $? != "0" ];do
		sleep 1s
		echo .
		check_url http://your ip:25081/store/mall.htm "商城"
	done
	nginx_change store_76_rec
	service_restart store_94
        $ssh_tbl94 "rm -rf $tbl_store_ro_path/webapps/ROOT.war"
	$ssh_tbl94 "rm -rf $tbl_store_ro_path/webapps/ROOT"
        $ssh_tbl94 "mv $tbl_store_ro_path/webapps/ROOT.war1 $tbl_store_ro_path/webapps/ROOT.war"
	service_restart store_94
	check_url http://your ip:25081/store/mall.htm  "商城"
        while [ $? != "0" ];do
                sleep 1s
                echo -n "."
                check_url http://your ip:25081/store/mall.htm "商城"
        done
	service_restart store_94_rec
}
zl_store(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
        fi
        mvn tbl_store
        if [ $? -ne 0 ];then
                echo "tbl_rescue编译失败!"
        fi
        for i in `cat $tbl_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_tbl76 "mv $tbl_store_ro_path/webapps/ROOT/$path $tbl_store_ro_path/webapps/ROOT/$path-$date_name"
                $ssh_tbl94 "mv $tbl_store_ro_path/webapps/ROOT/$path $tbl_store_ro_path/webapps/ROOT/$path-$date_name"
                init_scp $tbl_store_local_path/target/Webapp/$path $tbl_store_ro_path/webapps/ROOT/$path
                $scp_tbl76
                $scp_tbl94
                echo "已更新文件"
                $ssh_tbl76 "ls -al $tbl_store_ro_path/webapps/ROOT/$path"
                $ssh_tbl94 "ls -al $tbl_store_ro_path/webapps/ROOT/$path"
        done
        if [ $1 == "r" ];then
                nginx_change store_76
                service_restart store_76
                check_url http://your ip:25081/store/mall.htm "商城"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://your ip:25081/store/mall.htm "商城"
                done
                nginx_change store_76_rec
                nginx_change store_94
                service_restart store_94
                check_url http://your ip:25081/store/mall.htm "商城"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://your ip:25081/store/mall.htm "商城"
                done
                nginx_change store_94_rec
        fi
}
zl_tblm(){
	mvn tblservice
	if [ $? -ne 0 ];then
		echo "tblservice编译失败！"
		exit 1
	fi
        mvn tblm
        for i in `cat $tblm_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_tbl99 "mv $tblm_ro_path/webapps/ROOT/$path $tblm_ro_path/webapps/ROOT/$path-$date_name"
                init_scp $tblm_local_path/target/Webapp/$path $tblm_ro_path/webapps/ROOT/$path
                $scp_tbl99
                echo "已更新文件"
                $ssh_tbl99 "ls -al $tblm_ro_path/webapps/ROOT/$path"
        done
        if [ $1 == "r" ];then
		tblm_t1 start
		check_url http://IP:20180/login/forward_login.htm "登录"
		while [ $? != "0" ];do
			sleep 1s
			echo -n "."
			check_url http://IP:20180/login/forward_login.htm "登录"
		done
		nginx_change tblm
                service_restart tblm
                check_url http://IP:20080/login/forward_login.htm "登录"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://IP:20080/login/forward_login.htm "登录"
                done
		nginx_change tblm_rec
		tblm_t1 stop
        fi      
}
zl_tbl_jy(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
        fi
        mvn tbl_rescue
        if [ $? -ne 0 ];then
                echo "tbl_rescue编译失败!"
        fi
        for i in `cat $tbl_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_tbl76 "mv $tbl_jy_ro_path/webapps/ROOT/$path $tbl_jy_ro_path/webapps/ROOT/$path-$date_name"
                $ssh_tbl94 "mv $tbl_jy_ro_path/webapps/ROOT/$path $tbl_jy_ro_path/webapps/ROOT/$path-$date_name"
                init_scp $tbl_rescue_local_path/target/Webapp/$path $tbl_jy_ro_path/webapps/ROOT/$path
                $scp_tbl76
                $scp_tbl94
                echo "已更新文件"
                $ssh_tbl76 "ls -al $tbl_jy_ro_path/webapps/ROOT/$path"
                $ssh_tbl94 "ls -al $tbl_jy_ro_path/webapps/ROOT/$path"
        done
        if [ $1 == "r" ];then
#                nginx_change tbl_76
                service_restart tbl76
		sleep 3s
                check_url http://your ip:24080/team/jiuyuan_login.htm "两步路公益救援指挥平台"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://your ip:24080/team/jiuyuan_login.htm "两步路公益救援指挥平台"
                done
#                nginx_change tbl_76_rec
#                nginx_change tbl_94
                service_restart tbl94
		sleep 3s
                check_url http://your ip:24080/team/jiuyuan_login.htm "两步路公益救援指挥平台"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://your ip:24080/team/jiuyuan_login.htm "两步路公益救援指挥平台"
                done
#                nginx_change tbl_94_rec
        fi		
}
zl_tbl_test(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                exit 1
        fi
	mvn tbl_fz
        for i in `cat $tbl_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_tbl193 "mv $tbl_fz_ro_path/webapps/tbl/$path $tbl_fz_ro_path/webapps/tbl/$path-$date_name"
                init_scp $tbl_local_path/target/Webapp/$path $tbl_fz_ro_path/webapps/tbl/$path
                $scp_tbl193
                #$ssh_tbl76 "ls -al $tbl_ro_path/webapps/ROOT/$path"
                echo "已更新文件"
                $ssh_tbl193 "ls -al $tbl_fz_ro_path/webapps/tbl/$path"
        done
        if [ $1 == "r" ];then
		service_restart tbl_fz
		check_url http://IP:16080/tbl/about/app_download2.htm?id=0 "户外助手官方下载"
		while [ $? != "0" ];do
        		sleep 1s
        		echo -n "."
        		check_url http://IP:16080/tbl/about/app_download2.htm?id=0 "户外助手官方下载"
		done
	fi

}
zl_tblm_test(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                exit 1
        fi
        mvn tblm_fz
        for i in `cat $tblm_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_tbl193 "mv $tbl_fz_ro_path/webapps/tblm/$path $tbl_fz_ro_path/webapps/tblm/$path-$date_name"
                init_scp $tblm_local_path/target/Webapp/$path $tbl_fz_ro_path/webapps/tblm/$path
                $scp_tbl193
                echo "已更新文件"
                $ssh_tbl193 "ls -al $tbl_fz_ro_path/webapps/tblm/$path"
        done
        if [ $1 == "r" ];then
                service_restart tbl_fz
        fi
}
event_service(){
	mvn event_service
	cd $event_service_local_path/target/classes
	rm -rf com.zip
	zip -r com.zip com
	if [ $? -ne 0 ];then
		exit 1
	fi	
	echo "打包完成..."
	$ssh_tbl99 "rm $event_service_ro_path/classes/com.zip"
	$ssh_tbl67 "rm $event_service_ro_path/classes/com.zip"
	
	echo '远程临时文件删除完成...'
	init_scp $event_service_local_path/target/classes/com.zip $event_service_ro_path/classes/
	$scp_tbl99
	$scp_tbl67
	echo '文件以及上传完成...'
	$ssh_tbl99 "mv $event_service_ro_path/classes/com $event_service_ro_path/classes/com_$date_name"
	$ssh_tbl67 "mv $event_service_ro_path/classes/com $event_service_ro_path/classes/com_$date_name"
	
	$ssh_tbl99 "unzip $event_service_ro_path/classes/com.zip -d $event_service_ro_path/classes/"
	$ssh_tbl67 "unzip $event_service_ro_path/classes/com.zip -d $event_service_ro_path/classes/"
	echo "代码更新完成..."
	service_restart event_service99
	service_restart event_service67
}
zl_event_service(){
        mvn event_service
        for i in `cat $helper_txt`;do
                echo "$i" | grep jar
                if [ $? -eq 0 ];then
                        jar_file=`echo $i | awk -F '/' '{print $2}' | sed 's/[0-9]/*/g'`
                        $ssh_tbl99 "mv $event_service_ro_path/lib/$jar_file $event_service_ro_path/lib/$jar_file-$date_name"
                        $ssh_tbl67 "mv $event_service_ro_path/lib/$jar_file $event_service_ro_path/lib/$jar_file-$date_name"
                        init_scp $event_service_local_path/target/$i $event_service_ro_path/$i
                        $scp_tbl99
                        $scp_tbl67
                        echo "已更新文件"
                        $ssh_tbl99 "ls -al $event_service_ro_path/$i"
                        $ssh_tbl67 "ls -al $event_service_ro_path/$i"
                        init_scp $event_service_local_path/target/$i $event_service_ro_path/$i
                        $scp_tbl99
                        $scp_tbl67
                        echo "已更新文件"
                        $ssh_tbl99 "ls -al $event_service_ro_path/$i"
                        $ssh_tbl67 "ls -al $event_service_ro_path/$i"
                else
                        $ssh_tbl99 "mv $event_service_ro_path/$i $event_service_ro_path/$i-$date_name"
                        $ssh_tbl67 "mv $event_service_ro_path/$i $event_service_ro_path/$i-$date_name"
                        init_scp $event_service_local_path/target/$i $event_service_ro_path/$i
                        $scp_tbl99
                        $scp_tbl67
                        echo "已更新文件"
                        $ssh_tbl76 "ls -al $event_service_ro_path/$i"
                        $ssh_tbl94 "ls -al $event_service_ro_path/$i"
                fi
        done
        if [ $1 == "r" ];then
                service_restart event_service99
                service_restart event_service67
        fi
}
zl_helper(){
	mvn helper
	for i in `cat $helper_txt`;do
		echo "$i" | grep jar
		if [ $? -eq 0 ];then
			jar_file=`echo $i | awk -F '/' '{print $2}' | sed 's/[0-9]/*/g'`
			$ssh_tbl76 "mv $helper_ro_path/lib/$jar_file $helper_ro_path/lib/$jar_file-$date_name"
			$ssh_tbl94 "mv $helper_ro_path/lib/$jar_file $helper_ro_path/lib/$jar_file-$date_name"
			init_scp $helper_local_path/target/$i $helper_ro_path/$i
			$scp_tbl76
			$scp_tbl94
			echo "已更新文件"
			$ssh_tbl76 "ls -al $helper_ro_path/$i"
			$ssh_tbl94 "ls -al $helper_ro_path/$i"
		else
                        $ssh_tbl76 "mv $helper_ro_path/$i $helper_ro_path/$i-$date_name"
                        $ssh_tbl94 "mv $helper_ro_path/$i $helper_ro_path/$i-$date_name"
                        init_scp $helper_local_path/target/$i $helper_ro_path/$i
                        $scp_tbl76
                        $scp_tbl94
                        echo "已更新文件"
                        $ssh_tbl76 "ls -al $helper_ro_path/$i"
                        $ssh_tbl94 "ls -al $helper_ro_path/$i"
		fi
	done
        if [ $1 == "r" ];then
		service_restart helper_netty76
		service_restart helper_netty94
        fi
}
zl_hwzs(){
        mvn hwzs
        for i in `cat $hwzs_txt`;do
                echo "$i" | grep jar
                if [ $? -eq 0 ];then
                        jar_file=`echo $i | awk -F '/' '{print $2}' | sed 's/[0-9]/*/g'`
                        $ssh_tbl76 "mv $hwzs_ro_path/lib/$jar_file $hwzs_ro_path/lib/$jar_file-$date_name"
                        $ssh_tbl94 "mv $hwzs_ro_path/lib/$jar_file $hwzs_ro_path/lib/$jar_file-$date_name"
                        init_scp $hwzs_local_path/target/$i $hwzs_ro_path/$i
                        $scp_tbl76
                        $scp_tbl94
                        echo "已更新文件"
                        $ssh_tbl76 "ls -al $hwzs_ro_path/$i"
                        $ssh_tbl94 "ls -al $hwzs_ro_path/$i"
                else
                        $ssh_tbl76 "mv $hwzs_ro_path/$i $hwzs_ro_path/$i-$date_name"
                        $ssh_tbl94 "mv $hwzs_ro_path/$i $hwzs_ro_path/$i-$date_name"
                        init_scp $hwzs_local_path/target/$i $hwzs_ro_path/$i
                        $scp_tbl76
                        $scp_tbl94
                        echo "已更新文件"
                        $ssh_tbl76 "ls -al $hwzs_ro_path/$i"
                        $ssh_tbl94 "ls -al $hwzs_ro_path/$i"
                fi
        done
        if [ $1 == "r" ];then
                service_restart hwzs76
                service_restart hwzs94
        fi
}
zl_nt(){
	mvn nthttp
	for i in `cat $nthttp_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do	
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_nt248 "mv $nthttp_ro_path/webapps/possecu/$path $nthttp_ro_path/webapps/possecu/$path-$date_name"
		$ssh_nt28 "mv $nthttp_ro_path/webapps/possecu/$path $nthttp_ro_path/webapps/possecu/$path-$date_name"
                init_scp $nthttp_local_path/target/ns_possecu/$path $nthttp_ro_path/webapps/possecu/$path
                $scp_nt248
		$scp_nt28
                echo "已更新文件"
                $ssh_nt248 "ls -al $nthttp_ro_path/webapps/possecu/$path"
		$ssh_nt28 "ls -al $nthttp_ro_path/webapps/possecu/$path"
	done
        if [ $1 == "r" ];then
                service_restart nt248_http
		service_restart nt28_http
        fi
}
zl_nt_test(){
        mvn nthttp
        for i in `cat $nthttp_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_nt248 "mv $nthttp_test_ro_path/webapps/ns_possecu/$path $nthttp_test_ro_path/webapps/ns_possecu/$path-$date_name"
                init_scp $nthttp_local_path/target/ns_possecu/$path $nthttp_test_ro_path/webapps/ns_possecu/$path
                $scp_nt248
                echo "已更新文件"
                $ssh_nt248 "ls -al $nthttp_test_ro_path/webapps/ns_possecu/$path"
        done
        if [ $1 == "r" ];then
                service_restart nthttp_test
        fi
}
zl_nt_demo(){
        mvn ntdemo
        for i in `cat $nthttp_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_nt28 "mv $ntdemo_ro_path/webapps/possecu_cs/$path $ntdemo_ro_path/webapps/possecu_cs/$path-$date_name"
                init_scp $ntdemo_local_path/target/ns_possecu/$path $ntdemo_ro_path/webapps/possecu_cs/$path
                $scp_nt28
                echo "已更新文件"
                $ssh_nt28 "ls -al $ntdemo_ro_path/webapps/possecu_cs/$path"
        done
        if [ $1 == "r" ];then
                service_restart nt_demo
        fi
}
zl_nt_baoji(){
        mvn nthttpbj
        for i in `cat $nthttp_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_nt28 "mv $nthttpbj_ro_path/webapps/possecu/$path $nthttpbj_ro_path/webapps/possecu/$path-$date_name"
                init_scp $nthttpbj_local_path/target/ns_possecu/$path $nthttpbj_ro_path/webapps/possecu/$path
                $scp_nt28
                echo "已更新文件"
                $ssh_nt28 "ls -al $nthttpbj_ro_path/webapps/possecu/$path"
        done
        if [ $1 == "r" ];then
                service_restart nt_baoji
        fi
}
zl_nt_jiedao(){
        mvn ntjiedao
        for i in `cat $nthttp_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_nt28 "mv $nthttpjiedao_ro_path/webapps/possecu/$path $nthttpjiedao_ro_path/webapps/possecu/$path-$date_name"
                init_scp $ntdemo_local_path/target/ns_possecu/$path $nthttpjiedao_ro_path/webapps/possecu/$path
                $scp_nt28
                echo "已更新文件"
                $ssh_nt28 "ls -al $nthttpjiedao_ro_path/webapps/possecu/$path"
        done
        if [ $1 == "r" ];then
                service_restart nt_jiedao
        fi
}
nt_baoji(){
	mvn nthttpbj
	$ssh_nt28 "mv $nthttpbj_ro_path/webapps/possecu $nthttpbj_ro_path/webappback/possecu_$date_name"
	$ssh_nt28 "mv $nthttpbj_ro_path/webapps/possecu.war $nthttpbj_ro_path/webappback/possecu.war_$date_name"
	$ssh_nt28 "rm -rf  $nthttpbj_ro_path/webapps/possecu*"
	init_scp $nthttpbj_local_path/target/ns_possecu.war $nthttpbj_ro_path/webapps/possecu.war
	$scp_nt28
        service_restart nt_baoji
}
nt_jiedao(){
        mvn ntjiedao
        $ssh_nt28 "mv $nthttpjiedao_ro_path/webapps/possecu $nthttpjiedao_ro_path/webappback/possecu_$date_name"
        $ssh_nt28 "mv $nthttpjiedao_ro_path/webapps/possecu.war $nthttpjiedao_ro_path/webappback/possecu.war_$date_name"
        $ssh_nt28 "rm -rf $nthttpjiedao_ro_path/webapps/possecu*"
        init_scp $ntdemo_local_path/target/ns_possecu.war $nthttpjiedao_ro_path/webapps/possecu.war
        $scp_nt28
        service_restart nt_jiedao
}
lg_http(){
        mvn lghttp
	$ssh_lg229 "mv $lghttp_ro_path/webapps/ROOT $lghttp_ro_path/webappback/ROOT_$date_name"
	$ssh_lg229 "mv $lghttp_ro_path/webapps/ROOT.war $lghttp_ro_path/webappback/ROOT.war_$date_name"
        $ssh_lg229 "rm -rf $lghttp_ro_path/webapps/*"
        init_scp $lghttp_local_path/target/ns_possecu.war $lghttp_ro_path/webapps/ROOT.war
        $scp_lg229
        service_restart lghttp_229

        $ssh_lg108 "mv $lghttp_ro_path/webapps/ROOT $lghttp_ro_path/webappback/ROOT_$date_name"
        $ssh_lg108 "mv $lghttp_ro_path/webapps/ROOT.war $lghttp_ro_path/webappback/ROOT.war_$date_name"
        $ssh_lg108 "rm -rf $lghttp_ro_path/webapps/*"
        init_scp $lghttp_local_path/target/ns_possecu.war $lghttp_ro_path/webapps/ROOT.war
        $scp_lg108
        service_restart lghttp_108
}
zl_lg_http(){
        mvn lghttp
        for i in `cat $nthttp_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                path=`echo $i | awk -F 'webapp' '{print $2}'`
                $ssh_lg229 "mv $lghttp_ro_path/webapps/ROOT/$path $lghttp_ro_path/webapps/ROOT/$path-$date_name"
		$ssh_lg108 "mv $lghttp_ro_path/webapps/ROOT/$path $lghttp_ro_path/webapps/ROOT/$path-$date_name"
                init_scp $lghttp_local_path/target/ns_possecu/$path $lghttp_ro_path/webapps/ROOT/$path
                $scp_lg229
		$scp_lg108
                echo "已更新文件"
                $ssh_lg229 "ls -al $lghttp_ro_path/webapps/ROOT/$path"
		$ssh_lg108 "ls -al $lghttp_ro_path/webapps/ROOT/$path"
        done
        if [ $1 == "r" ];then
                service_restart lghttp_229
		service_restart lghttp_108
        fi
}
tbl(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                exit 1
        fi
	cd /data/project
	crontab tbl_76 stop
	crontab tbl_94 stop
        ./tbl.sh production
	crontab tbl_76 start
	crontab tbl_94 start
}
tbl_fz(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                exit 1
        fi
	cd /data/project
        ./tbl.sh test1
}
tblm(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                exit 1
        fi
	crontab tbl_99 stop
	tblm_t1 start
	check_url http://IP:20180/login/forward_login.htm "登录" r
	nginx_change tblm
	cd /data/project
        ./tblm.sh production
	check_url http://IP:20080/login/forward_login.htm "登录" r
	nginx_change tblm_rec
	tblm_t1 stop
	crontab tbl_99 start
}
tblm_fz(){
        mvn tblservice
        if [ $? -ne 0 ];then
                echo "tblservice编译失败！"
                0exit 1
        fi
	cd /data/project
        ./tblm.sh test1
}
tbl_jy(){
	mvn tblservice
	if [ $? -ne 0 ];then
		echo "tblservice编译失败！"
	fi
	mvn tbl_rescue
	if [ $? -ne 0 ];then
		echo "tbl_rescue编译失败!"
	fi
	init_scp $tbl_rescue_local_path/target/Webapp.war $tbl_jy_ro_path/webapps/ROOT.war-
	$scp_tbl76
	$scp_tbl94
	#备份76旧版本并改ROOT.war-#
	$ssh_tbl76 "mv  $tbl_jy_ro_path/webapps/ROOT.war $tbl_jy_ro_path/webappback/ROOT.war-$date_name"
	$ssh_tbl76 "mv  $tbl_jy_ro_path/webapps/ROOT $tbl_jy_ro_path/webappback/ROOT-$date_name"
	$ssh_tbl76 "mv  $tbl_jy_ro_path/webapps/ROOT.war- $tbl_jy_ro_path/webapps/ROOT.war"
	#备份94旧版本并改ROOT.war-#
        $ssh_tbl94 "mv  $tbl_jy_ro_path/webapps/ROOT.war $tbl_jy_ro_path/webappback/ROOT.war-$date_name"
        $ssh_tbl94 "mv  $tbl_jy_ro_path/webapps/ROOT $tbl_jy_ro_path/webappback/ROOT-$date_name"
	$ssh_tbl94 "mv  $tbl_jy_ro_path/webapps/ROOT.war- $tbl_jy_ro_path/webapps/ROOT.war"
}
mongodbtx(){
	mvn mongodbtx
	if [ $? -ne 0 ];then
		echo "$!编译失败!"
	fi
	init_scp $mongodbtx_local_path/target/*.jar $mongodbtx_ro_path/mongodbtx.jar
	$ssh_tbl99 "$mongodbtx_ro_path/mongodbtx.sh stop"
	$ssh_tbl99 "mv $mongodbtx_ro_path/mongodbtx.jar $mongodbtx_ro_path/mongodbtx.jar$date_name"
	$scp_tbl99
	$ssh_tbl99 "$mongodbtx_ro_path/mongodbtx.sh start"
}
tbl_file(){
        mvn tbl_file
        if [ $? -ne 0 ];then
                echo "$1编译失败!"
        fi
	cd $tbl_file_local_path/target/classes/
	rm com.zip
	zip -r com.zip com
        init_scp $tbl_file_local_path/target/classes/com.zip $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com.zip
	$ssh_tbl94 "rm $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com.zip"
	$ssh_tbl99 "rm $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com.zip"
        $ssh_tbl94 "mv $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com-$date_name"
        $ssh_tbl99 "mv $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com-$date_name"
	$scp_tbl94
	$scp_tbl99
        $ssh_tbl94 "unzip -o $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com.zip -d $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/"
	$ssh_tbl99 "unzip -o $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/com.zip -d $tbl_file_ro_path/webapps/ROOT/WEB-INF/classes/"
        service_restart tbl_file94
	service_restart tbl_file99
}
event(){
        mvn event_pro
        if [ $? -ne 0 ];then
                echo "$1编译失败!"
        fi
        init_scp $event_local_path/target/*.war $event_ro_path/webapps/ROOT.war
	nginx_change eventhttp_67
	$ssh_tbl67 "mv $event_ro_path/webapps/ROOT $event_ro_path/webappback/ROOT_$date_name"
	$ssh_tbl67 "mv $event_ro_path/webapps/ROOT.war $event_ro_path/webappback/ROOT.war_$date_name"
        $scp_tbl67
	$ssh_tbl67 "unzip -o $event_ro_path/webapps/ROOT.war -d $event_ro_path/webapps/ROOT"
	service_restart eventhttp_67
	check_url http://IP:8200 "这个页面"
	while [ $? != "0" ];do
		sleep 1s
		echo -n "."
		check_url http://IP:8200 "这个页面"
	done
	nginx_change eventhttp_67_rec
	nginx_change eventhttp_99
        $ssh_tbl99 "mv $event_ro_path/webapps/ROOT $event_ro_path/webappback/ROOT_$date_name"
        $ssh_tbl99 "mv $event_ro_path/webapps/ROOT.war $event_ro_path/webappback/ROOT.war_$date_name"
        $scp_tbl99
	$ssh_tbl99 "unzip -o $event_ro_path/webapps/ROOT.war -d $event_ro_path/webapps/ROOT"
	service_restart eventhttp_99
        check_url http://IP:8200 "这个页面"
        while [ $? != "0" ];do
                sleep 1s
                echo -n "."
                check_url http://IP:8200 "这个页面"
        done
        nginx_change eventhttp_99_rec
}
zl_event(){
        mvn event_pro
        if [ $? -ne 0 ];then
                echo "$1编译失败!"
        fi		
        for i in `cat $tbl_txt | sed "s/src\/main\/java/webapp\/WEB-INF\/classes/g" | sed  "s/\.java/\.class/g"`;do
                #path=`echo $i | awk -F 'resources' '{print $2}'`
                echo $i | grep "class"
                if [ $? -eq 0 ];then
                        path=`echo $i | awk -F 'classes' '{print $2}'`
                        echo $path
                else
			path=`echo $i | awk -F 'resources' '{print $2}'`
		fi	
		if [ "path" == "" ];then
			path=`echo $i | awk -F 'java' '{print $2}'`
		fi
                $ssh_tbl67 "mv $event_ro_path/webapps/ROOT/WEB-INF/classes/$path $event_ro_path/webapps/ROOT/WEB-INF/classes/$path-$date_name"
                $ssh_tbl99 "mv $event_ro_path/webapps/ROOT/WEB-INF/classes/$path $event_ro_path/webapps/ROOT/WEB-INF/classes/$path-$date_name"
                init_scp $event_local_path/target/event-1.5.6.RELEASE/WEB-INF/classes/$path $event_ro_path/webapps/ROOT/WEB-INF/classes/$path
                $scp_tbl67
                $scp_tbl99
                echo "已更新文件"
                $ssh_tbl67 "ls -al $event_ro_path/webapps/ROOT/WEB-INF/classes/$path"
                $ssh_tbl99 "ls -al $event_ro_path/webapps/ROOT/WEB-INF/classes/$path"
        done
        if [ $1 == "r" ];then
                nginx_change eventhttp_67
                service_restart eventhttp_67
                check_url http://IP:8200 "这个页面"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://IP:8200 "这个页面"
                done
                nginx_change eventhttp_67_rec
                nginx_change eventhttp_99
                service_restart eventhttp_99
                check_url http://IP:8200 "这个页面"
                while [ $? != "0" ];do
                        sleep 1s
                        echo -n "."
                        check_url http://IP:8200 "这个页面"
                done
                nginx_change eventhttp_99_rec
        fi
}
fz(){
	if [ "$1" == "" ] || [ "$1" == "help" ];then
#        if [ "$1" == "" ] || [ "$1" == "help" ] || [ "$1" != "tbl_event"] || [ "$1" != "tbl_other" ] || [ "$1" != "tbl_rescue" ] || [ "$1" != "tbl_store" ];then
		echo "By: w5750584@gmail.com"
		echo " 参数"
		echo "	help		查看帮助(help)"
                exit 0
        fi
	if [ "$1" == "tbl_event" ];then
        	mvn tblservice_event
        	if [ $? -ne 0 ];then
                	echo "tblservice编译失败！"
                	exit 1
        	fi
		mvn tbl_event
		if [ $? -ne 0 ];then
			echo "tbl_event编译失败!"
			exit 1
		fi
		init_scp $tbl_event_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tbl.war
	fi
        if [ "$1" == "tbl_other" ];then
                mvn tblservice_other
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tbl_other
                if [ $? -ne 0 ];then
                        echo "tbl_other编译失败!"
                        exit 1
                fi
                init_scp $tbl_other_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tbl.war
        fi
        if [ "$1" == "tbl_rescue" ];then
                mvn tblservice_rescue
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tbl_rescue
                if [ $? -ne 0 ];then
                        echo "tbl_rescue编译失败!"
                        exit 1
                fi
                init_scp $tbl_rescue_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tbl.war
        fi
        if [ "$1" == "tbl_store" ];then
                mvn tblservice
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tbl_store
                if [ $? -ne 0 ];then
                        echo "tbl_event编译失败!"
                        exit 1
                fi
                init_scp $tbl_store_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/ROOT.war
		$scp_tbl193
		$ssh_tbl193 "unzip -o $tbl_fz_ro_path/webapps/ROOT.war -d $tbl_fz_ro_path/webapps/ROOT"
		$ssh_tbl193 "$tbl_fz_ro_path/r.sh rr"
		exit 0
	
        fi
        if [ "$1" == "tbl_b_store" ];then
                mvn tblservice_store
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tbl_b_store
                if [ $? -ne 0 ];then
                        echo "tbl_event编译失败!"
                        exit 1
                fi
                init_scp $tbl_b_store_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tbl.war
        fi
        if [ "$1" == "tbl_production" ];then
                mvn tblservice_production
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tbl_production
                if [ $? -ne 0 ];then
                        echo "tbl_production编译失败!"
                        exit 1
                fi
                init_scp $tbl_production_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tbl.war
        fi
	res1=`echo $1 | grep tbl_`
	if [ "$res1" != "" ];then
		$ssh_tbl193 "rm -rf $tbl_fz_ro_path/webapps/tbl.war $tbl_fz_ro_path/webapps/tbl"
		$scp_tbl193
		echo "$1 :已更新"
		check_url http://IP:16080/tbl/about/app_download2.htm?id=0 "户外助手官方下载"
		while [ $? != "0" ];do
			sleep 1s
			echo -n "."
			check_url http://IP:16080/tbl/about/app_download2.htm?id=0 "户外助手官方下载"
		done
	fi
        if [ "$1" == "tblm_event" ];then
                mvn tblservice_event
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tblm_event
                if [ $? -ne 0 ];then
                        echo "tblm_event编译失败!"
                        exit 1
                fi
                init_scp $tblm_event_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tblm.war
        fi
        if [ "$1" == "tblm_other" ];then
                mvn tblservice_other
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tblm_other
                if [ $? -ne 0 ];then
                        echo "tblm_other编译失败!"
                        exit 1
                fi
                init_scp $tblm_other_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tblm.war
        fi
        if [ "$1" == "tblm_rescue" ];then
                mvn tblservice_rescue
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tblm_rescue
                if [ $? -ne 0 ];then
                        echo "tblm_rescue编译失败!"
                        exit 1
                fi
                init_scp $tblm_rescue_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tblm.war
        fi
        if [ "$1" == "tblm_store" ];then
                mvn tblservice_store
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tblm_store
                if [ $? -ne 0 ];then
                        echo "tblm_event编译失败!"
                        exit 1
                fi
                init_scp $tblm_store_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tblm.war
        fi
        if [ "$1" == "tblm_b_store" ];then
                mvn tblservice_store
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tblm_b_store
                if [ $? -ne 0 ];then
                        echo "$1编译失败!"
                        exit 1
                fi
                init_scp $tblm_b_store_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tblm.war
        fi
        if [ "$1" == "tblm_master" ];then
                mvn tblservice
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tblm
                if [ $? -ne 0 ];then
                        echo "tblm编译失败!"
                        exit 1
                fi
                init_scp $tblm_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tblm.war
        fi
        if [ "$1" == "tblm_production" ];then
                mvn tblservice_production
                if [ $? -ne 0 ];then
                        echo "tblservice编译失败！"
                        exit 1
                fi
                mvn tblm_production
                if [ $? -ne 0 ];then
                        echo "tblm_production编译失败!"
                        exit 1
                fi
                init_scp $tblm_production_local_path/target/Webapp.war $tbl_fz_ro_path/webapps/tblm.war
        fi

        if [ "$1" == "event" ];then
                mvn event_fz
                if [ $? -ne 0 ];then
                        echo "$1编译失败！"
                        exit 1
                fi
                init_scp $event_local_path/target/*.war $event_fz_ro_path/webapps/ROOT.war
		$ssh_tbl193 "rm -rf $event_fz_ro_path/webapps/*"
		$scp_tbl193
		echo "$1 :已更新"
		echo "http://IP:16082/"
        fi
        res1=`echo $1 | grep tblm_`
        if [ "$res1" != "" ];then
                $ssh_tbl193 "rm -rf $tbl_fz_ro_path/webapps/tblm.war $tbl_fz_ro_path/webapps/tblm"
                $scp_tbl193
                echo "$1 :已更新"
                check_url http://IP:16080/tblm/login/forward_login.htm "登录"
                while [ $? != "0" ];do
                        sleep 1s
                        echo .
                        check_url http://IP:16080/tblm/login/forward_login.htm "登录"
                done
        fi
}
helper(){
	./update.sh helper_netty
}
hwzs(){
	./update.sh hwzs
}
nt(){
	./update.sh nt
}
nt_tcp(){
	./update.sh nt_tcp
}
nt_demo(){
	./update.sh nt_demo
}
#nt_jiedao(){
#	./update.sh nt_jiedao
#}
nt_test(){
	./update.sh nt_test
}
case "$1" in
$1)
        if [ "$1" == "" ];then
                help
                exit 0
        fi
	$1 $2 $3 $4 
	if [ $? -ne 0 ];then
		echo "未知参数..."
	fi
	;;
*)
	exit 1
esac
exit 0

