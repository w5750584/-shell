#!/bin/bash
. ./includes/inc_common.sh
service_restart(){
	init_ssh
        if [ "$1" == "help" ] || [ "$1" == "" ];then
                        echo "参数:"
                        echo "  tbl76 | tbl94 | tbl_fz | helper_netty76 | helper_netty94 | tblm | hwzs76 | hwzs94 | nt248_tcp | nt28_tcp | nt248_http | nt28_http | nt_demo | nthttp_test | store_94 | store_76"
			exit 0
        fi
	echo "正在重启服务:$1"
	if [ $1 == "tbl76" ];then
			$ssh_tbl76 "/data/application/nginx_tomcat/new_2bulu/r.sh rr"
	fi
	if [ $1 == "tbl94" ];then
			$ssh_tbl94 "/data/application/nginx_tomcat/new_2bulu/r.sh rr"
	fi
        if [ $1 == "tbl_file94" ];then
                        $ssh_tbl94 "/data/application/nginx_tomcat/files_2bulu/r.sh rr"
        fi
        if [ $1 == "tbl_file99" ];then
                        $ssh_tbl99 "/data/application/nginx_tomcat/files_2bulu/r.sh rr"
        fi
        if [ $1 == "tbl_fz" ];then
                        $ssh_tbl193 "/data/application/nginx_tomcat/fz_2bulu/r.sh rr"
        fi
	if [ $1 == "helper_netty76" ];then
			$ssh_tbl76 "/data/application/helper-netty/bin/helper.sh restart"
	fi
	if [ $1 == "helper_netty94" ];then
			$ssh_tbl94 "/data/application/helper-netty/bin/helper.sh restart"
	fi
        if [ $1 == "event_service99" ];then
                        $ssh_tbl99 "/data/application/event-service/bin/event-service.sh restart"
        fi              
        if [ $1 == "event_service67" ];then
                        $ssh_tbl67 "/data/application/event-service/bin/event-service.sh restart"
        fi
	if [ $1 == "tblm" ];then
			$ssh_tbl99 "/data/application/nginx_tomcat/operation_2bulu/r.sh rr"
	fi
	if [ $1 == "hwzs76" ];then
			$ssh_tbl76 "/data/application/helper-comm/bin/hwzs.sh restart"
	fi
	if [ $1 == "hwzs94" ];then
			$ssh_tbl94 "/data/application/helper-comm/bin/hwzs.sh restart"
	fi
	if [ $1 == "nt248_tcp" ];then
			$ssh_nt248 "/data/application/GenericProfessionServer_upgrade/bin/GenericProfessionServer_upgrade.sh restart"
	fi
	if [ $1 == "nt28_tcp" ];then
			$ssh_nt28 "/data/application/GenericProfessionServer_upgrade/bin/GenericProfessionServer_upgrade.sh restart"
	fi
        if [ $1 == "lg229_tcp" ];then
                        $ssh_lg229 "/data/application/GenericProfessionServer_upgrade/bin/GenericProfessionServer_upgrade.sh restart"
        fi
        if [ $1 == "lg108_tcp" ];then
                        $ssh_lg108 "/data/application/GenericProfessionServer_upgrade/bin/GenericProfessionServer_upgrade.sh restart"
        fi
	if [ $1 == "nt248_http" ];then
			$ssh_nt248 "/data/application/tomcat-nt/r.sh rr"
	fi
	if [ $1 == "nt28_http" ];then
			$ssh_nt28 "/data/application/tomcat-nt/r.sh rr"
	fi
	if [ $1 == "nt_demo" ];then
			$ssh_nt28 "/data/application/tomcat-demo/r.sh rr"
	fi
        if [ $1 == "nt_baoji" ];then
                        $ssh_nt28 "/data/application/tomcat-baoji/r.sh rr"
        fi
        if [ $1 == "nt_jiedao" ];then
                        $ssh_nt28 "/data/application/tomcat-jiedao/r.sh rr"
        fi
        if [ $1 == "lghttp_229" ];then
                        $ssh_lg229 "/data/application/tomcat-lg/r.sh rr"
        fi
        if [ $1 == "lghttp_108" ];then
                        $ssh_lg108 "/data/application/tomcat-lg/r.sh rr"
        fi
        if [ $1 == "nthttp_test" ];then
                        $ssh_nt248 "/data/application/tomcat-test/r.sh rr"
        fi
        if [ $1 == "store_76" ];then
                        $ssh_tbl76 "/data/application/nginx_tomcat/store_2bulu/r.sh rr"
        fi
        if [ $1 == "store_94" ];then
                        $ssh_tbl94 "/data/application/nginx_tomcat/store_2bulu/r.sh rr"
        fi

        if [ $1 == "store_99" ];then
                        $ssh_tbl99 "/data/application/nginx_tomcat/store_2bulu/r.sh rr"
        fi
        if [ $1 == "store_67" ];then
                        $ssh_tbl67 "/data/application/nginx_tomcat/store_2bulu/r.sh rr"
        fi
        if [ $1 == "store_193" ];then
                        $ssh_tbl193 "/data/application/nginx_tomcat/store_2bulu/r.sh rr"
        fi

	if [ $1 == "eventhttp_99" ];then
			$ssh_tbl99 "/data/application/nginx_tomcat/event_2bulu/r.sh rr"
	fi
        if [ $1 == "eventhttp_67" ];then
                        $ssh_tbl67 "/data/application/nginx_tomcat/event_2bulu/r.sh rr"
        fi
}
