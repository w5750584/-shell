#!/bin/bash
. /etc/profile
init_path(){
	tbl_local_path="/data/project/tbl"
	tblm_local_path="/data/project/tblm"
	tbl_file_local_path="/data/project/svn/FileSvr"
	helper_local_path="/data/project/svn/trunk"
	hwzs_local_path="/data/project/svn/tbl-hwzs"
	nttcp_local_path="/data/project/svn/GenericProfessionServer_NanShanFenJu"
	lgtcp_local_path="/data/project/svn/GenericProfessionServer_LongGangFenJu"
	nthttp_local_path="/data/project/svn/ns_possecu"
	ntdemo_local_path="/data/project/svn/nt_demo/ns_possecu"
	nthttpbj_local_path="/data/project/svn/nt_demo/ns_possecu"
	lghttp_local_path="/data/project/svn/nt_demo/ns_possecu"
	tbl_event_local_path="/data/project/svn/tbl-event"
	tbl_other_local_path="/data/project/svn/tbl-other"
	tbl_rescue_local_path="/data/project/svn/tbl-rescue"
	tbl_store_local_path="/data/project/svn/tbl-store"
	tbl_production_local_path="/data/project/svn/tbl-production"
	tblservice_local_path="/data/project/svn/tblservice"
	tblservice_event_local_path="/data/project/svn/tblservice-event"
	tblservice_other_local_path="/data/project/svn/tblservice-other"
	tblservice_rescue_local_path="/data/project/svn/tblservice-rescue"
	tblservice_store_local_path="/data/project/svn/tblservice-store"
	tblservice_production_local_path="/data/project/svn/tblservice-production"
	tblm_event_local_path="/data/project/svn/tblm-event"
	tblm_other_local_path="/data/project/svn/tblm-other"
	tblm_rescue_local_path="/data/project/svn/tblm-rescue"
	tblm_store_local_path="/data/project/svn/tblm-store"
	tblm_production_local_path="/data/project/svn/tblm-production"
	tblm_master_local_path="/data/project/tblm"	
	event_local_path="/data/project/svn/event"
	mongodbtx_local_path="/data/project/svn/mongodbtx"
	ecshop_local_path="/data/project/svn/ecshop"
	event_service_local_path='/data/project/svn/event-daoservice'

	tbl_b_store_local_path="/data/project/svn/branches/tbl-store"
	tblm_b_store_local_path="/data/project/svn/branches/tblm-store"
	ecshop_ro_path="/data/application/php-shop"
	mongodbtx_ro_path="/data/application/mongodbtx"
	event_ro_path="/data/application/nginx_tomcat/event_2bulu"
	event_fz_ro_path="/data/application/nginx_tomcat/fz_event"
	tbl_fz_ro_path="/data/application/nginx_tomcat/fz_2bulu"
	tbl_ro_path="/data/application/nginx_tomcat/new_2bulu"
	tbl_file_ro_path="/data/application/nginx_tomcat/files_2bulu"
	tbl_jy_ro_path="/data/application/nginx_tomcat/jy_2bulu"
	tbl_store_ro_path="/data/application/nginx_tomcat/store_2bulu"
	tblm_ro_path="/data/application/nginx_tomcat/operation_2bulu"
        helper_ro_path="/data/application/helper-netty"
	event_service_ro_path="/data/application/event-service"
        hwzs_ro_path="/data/application/helper-comm"
        nttcp_ro_path="/data/application/GenericProfessionServer_upgrade"
	lgtcp_ro_path="/data/application/GenericProfessionServer_upgrade"
        nthttp_ro_path="/data/application/tomcat-nt"
	nthttp_test_ro_path="/data/application/tomcat-test"
        ntdemo_ro_path="/data/application/tomcat-demo"
	nthttpbj_ro_path="/data/application/tomcat-baoji"
	nthttpjiedao_ro_path="/data/application/tomcat-jiedao"
	lghttp_ro_path="/data/application/tomcat-lg"
	tbl_txt="/data/project/tbl.txt"
	tblm_txt="/data/project/tblm.txt"
	helper_txt="/data/project/helper.txt"
	hwzs_txt="/data/project/hwzs.txt"
	nthttp_txt="/data/project/nthttp.txt"
	nttcp_txt="/data/project/nttcp.txt"
        sed -i 's#\\#\/#g' $tbl_txt
        sed -i 's#\\#\/#g' $tblm_txt
        sed -i 's#\\#\/#g' $helper_txt
        sed -i 's#\\#\/#g' $hwzs_txt
        sed -i 's#\\#\/#g' $nthttp_txt
        sed -i 's#\\#\/#g' $nttcp_txt
}
mvn(){
	init_path
        if [ "$1" == "help" ] || [ "$1" == "" ];then
                echo "参数:"
                echo -e "\ttbl\n\ttblm\n\ttbl_fz\n\ttblm_fz\n\ttbl_event\n\ttbl_other\n\ttbl_rescue\n\ttbl_store\n\thelper\n\thwzs\n\tnthttp\n\tnttcp\n\tntdemo\n\ttblservice"
		echo -e "\ttblm_event\n\ttblm_other\n\ttblm_rescue\n\ttblm_store\n\ttblservice_event\n\ttblservice_other\n\ttblservice_rescue\n\ttblservice_store"
		echo -e "\ttbl_production\n\ttblm_production\n\ttblservice_production\n\tnthttpbj"
                exit 0
        fi
	echo "正在编译$1,请稍等..."
	if [ $1 == "tbl" ];then
		cd $tbl_local_path
		svn up
		ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
	fi
	if [ $1 == "tblm" ];then
		cd $tblm_local_path
		svn up
		ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
	fi
        if [ $1 == "tbl_file" ];then
                cd $tbl_file_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile`
        fi
        if [ $1 == "tbl_fz" ];then
                cd $tbl_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pfz`
        fi
        if [ $1 == "tblm_fz" ];then
                cd $tblm_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pfz`
        fi
        if [ $1 == "tblm_event" ];then
                cd $tblm_event_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
        if [ $1 == "tblm_other" ];then
                cd $tblm_other_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
        if [ $1 == "tblm_rescue" ];then
                cd $tblm_rescue_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
        if [ $1 == "tblm_store" ];then
                cd $tblm_store_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
        if [ $1 == "tblm_production" ];then
                cd $tblm_production_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
	if [ $1 == "helper" ];then
		cd $helper_local_path
		svn up
		ret=`/usr/bin/mvn clean compile -U`
	fi
        if [ $1 == "event_service" ];then
                cd $event_service_local_path
                svn up
                ret=`/usr/bin/mvn clean compile -U`
        fi
	if [ $1 == "hwzs" ];then
		cd $hwzs_local_path
		svn up
		ret=`/usr/bin/mvn clean compile -U`
	fi
        if [ $1 == "lg_tcp" ];then
                cd $lgtcp_local_path
                svn up
                ret=`/usr/bin/mvn clean compile`
        fi
	if [ $1 == "nthttp" ];then
		cd $nthttp_local_path
		svn up
		ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
	fi
	if [ $1 == "nttcp" ];then
		cd $nttcp_local_path
		svn up
		ret=`/usr/bin/mvn clean compile`
	fi	
	if [ $1 == "ntdemo" ];then
		cd $ntdemo_local_path
		svn up
		ret=`/usr/bin/mvn -U clean compile war:war -Pdemo`
	fi
        if [ $1 == "ntjiedao" ];then
                cd $ntdemo_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pnantoujiedao`
        fi
	if [ $1 == "nthttpbj" ];then
		cd $nthttpbj_local_path
		svn up
		ret=`/usr/bin/mvn -U clean compile war:war -Pbaoji`
	fi
        if [ $1 == "lghttp" ];then
                cd $lghttp_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Plonggang`
        fi
	if [ $1 == "tbl_event" ];then
                cd $tbl_event_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
	fi
        if [ $1 == "tbl_other" ];then
                cd $tbl_other_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
        if [ $1 == "tbl_rescue" ];then
                cd $tbl_rescue_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi		
        if [ $1 == "tbl_store" ];then
                cd $tbl_store_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
        if [ $1 == "tbl_production" ];then
                cd $tbl_production_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi	
        if [ $1 == "tbl_b_store" ];then
                cd $tbl_b_store_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
        if [ $1 == "tblm_b_store" ];then
                cd $tblm_b_store_local_path
                svn up
                ret=`/usr/bin/mvn -U clean compile war:war -Pproduction`
        fi
	if [ $1 == "event_fz" ];then
		cd $event_local_path
		svn up
		ret=`/usr/bin/mvn  -U clean compile war:war -Pfz`
	fi
        if [ $1 == "event_pro" ];then
                cd $event_local_path
                svn up
                ret=`/usr/bin/mvn  -U clean compile war:war -Ppro`
        fi
	if [ $1 == "tblservice" ];then
		cd $tblservice_local_path
		svn up
		ret=`/usr/bin/mvn deploy -Dmaven.test.skip=true -U`
	fi
        if [ $1 == "tblservice_event" ];then
                cd $tblservice_event_local_path
                svn up
                ret=`/usr/bin/mvn deploy -Dmaven.test.skip=true -U`
        fi
        if [ $1 == "tblservice_other" ];then
                cd $tblservice_other_local_path
                svn up
                ret=`/usr/bin/mvn deploy -Dmaven.test.skip=true -U`
        fi
        if [ $1 == "tblservice_rescue" ];then
                cd $tblservice_rescue_local_path
                svn up
                ret=`/usr/bin/mvn deploy -Dmaven.test.skip=true -U`
        fi
        if [ $1 == "tblservice_store" ];then
                cd $tblservice_store_local_path
                svn up
                ret=`/usr/bin/mvn deploy -Dmaven.test.skip=true -U`
        fi
        if [ $1 == "tblservice_production" ];then
                cd $tblservice_production_local_path
                svn up
                ret=`/usr/bin/mvn deploy -Dmaven.test.skip=true -U`
        fi
	if [ $1 == "mongodbtx" ];then
		cd $mongodbtx_local_path
		svn up
		ret=`/usr/bin/mvn package -Dmaven.test.skip=true`
	fi
	echo "$ret"
	echo "$ret" | grep 'BUILD SUCCESS'
	if [ $? -ne 0 ];then
		exit 1
	fi
}
check_url(){
	if [ "$1" == "help" ] || [ "$1" == "" ];then
		echo "参数1 参数2 参数3"
		echo "URL 页面内容 轮询检测[r](如:check_url http://www.xxx.com "xxx")"
		exit 0
	fi
	echo "正在检查 [$1] 能否访问!"
#	curl -s --connect-timeout 5 -m 8 $1 | grep $2
	if [ "$3" == "r" ];then
		curl -s --connect-timeout 5 -m 8 $1 | grep $2
		while [ $? != "0" ];do
			sleep 1s
			echo -n .
			curl -s --connect-timeout 5 -m 8 $1 | grep $2
        	done
		return $?
	else
		curl -s --connect-timeout 5 -m 8 $1 | grep $2
		return $?
	fi
}
help(){
	echo "By: Xiaofeng.di@lolaage.com"
	echo " 参数1 参数2 参数3..."
	echo "		service_restart	重新启动服务"
	echo "		mvn		编译项目"
	echo "		check_url	检测地址url请求内容中是否包含变量(如:check_url http://www.xxx.com "xxx")"
	echo "		help		查看帮助"
}
