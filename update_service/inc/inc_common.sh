#/bin/bash
init_ssh(){
	ssh_tbl76="ssh -p 50750 root@ip"
	ssh_tbl94="ssh -p 50750 root@ip"
	ssh_tbl193="ssh -p 50750 root@ip"
	ssh_tbl99="ssh -p 50750 root@ip"
	ssh_tbl67="ssh -p 50750 root@ip"
	ssh_nt248="ssh -p 50750 root@ip"
	ssh_nt28="ssh -p 50750 root@ip"
	ssh_lg229="ssh  root@ip"
	ssh_lg108="ssh  root@ip"
}
init_scp(){
        if [ $1 != "" ];then
                scp_tbl76="scp -r -P 50750 $1 root@ip:"$2
                scp_tbl94="scp -r -P 50750 $1 root@ip4:"$2
		scp_tbl193="scp -r -P 50750 $1 root@ip:"$2
		scp_tbl99="scp -r -P 50750 $1 root@ip:"$2
		scp_tbl67="scp -r -P 50750 $1 root@ip:"$2
                scp_nt248="scp -r -P 50750 $1 root@ip:"$2
                scp_nt28="scp -r -P 50750 $1 root@ip:"$2
		scp_lg229="scp -r $1 root@ip:"$2
		scp_lg108="scp -r $1 root@ip:"$2
        else
		echo "scp参数丢失!"
		exit
	fi
}
nginx_change(){
	init_ssh
	case "$1" in
		tblm)
		$ssh_tbl76 "sed -i 's/10.80.226.189:20080/10.80.226.189:20180/g' /usr/local/nginx1/conf/nginx.conf"
		$ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload";;
		tbl_76)
		$ssh_tbl76 "sed -i 's/127.0.0.1:23080/10.27.0.168:23080/g' /usr/local/nginx1/conf/nginx.conf"
		$ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload";;
		tbl_94)
		$ssh_tbl94 "sed -i 's/127.0.0.1:23080/10.132.9.193:23080/g' /usr/local/nginx/conf/nginx.conf"
		$ssh_tbl94 "/usr/local/nginx/sbin/nginx -s reload";;
		store_76)
		$ssh_tbl76 "sed -i 's/127.0.0.1:25081/10.27.0.168:25081/g' /usr/local/nginx1/conf/nginx.conf"
		$ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload";;
		store_94)
                $ssh_tbl94 "sed -i 's/127.0.0.1:25081/10.132.9.193:25081/g' /usr/local/nginx/conf/nginx.conf"
                $ssh_tbl94 "/usr/local/nginx/sbin/nginx -s reload";;
		eventhttp_67)
		$ssh_tbl67 "sed -i 's/127.0.0.1:8200/10.80.226.189:8200/g' /usr/local/nginx/conf/nginx.conf"
		$ssh_tbl67 "/usr/local/nginx/sbin/nginx -s reload";;
                eventhttp_99)
                $ssh_tbl99 "sed -i 's/127.0.0.1:8200/10.241.104.193:8200/g' /usr/local/nginx/conf/nginx.conf"
                $ssh_tbl99 "/usr/local/nginx/sbin/nginx -s reload";;
		tblm_rec)
		$ssh_tbl76 "sed -i 's/10.80.226.189:20180/10.80.226.189:20080/g' /usr/local/nginx1/conf/nginx.conf"
		$ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload";;
		store_76_rec)
                $ssh_tbl76 "sed -i 's/10.27.0.168:25081/127.0.0.1:25081/g' /usr/local/nginx1/conf/nginx.conf"
                $ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload";;
		store_94_rec)
                $ssh_tbl94 "sed -i 's/10.132.9.193:25081/127.0.0.1:25081/g' /usr/local/nginx/conf/nginx.conf"
                $ssh_tbl94 "/usr/local/nginx/sbin/nginx -s reload";;
		tbl_76_rec)
		$ssh_tbl76 "sed -i 's/10.27.0.168:23080/127.0.0.1:23080/g' /usr/local/nginx1/conf/nginx.conf"
		$ssh_tbl76 "/usr/local/nginx1/sbin/nginx -s reload";;
                eventhttp_67_rec)
                $ssh_tbl67 "sed -i 's/10.80.226.189:8200/127.0.0.1:8200/g' /usr/local/nginx/conf/nginx.conf"
                $ssh_tbl67 "/usr/local/nginx/sbin/nginx -s reload";;
                eventhttp_99_rec)
                $ssh_tbl99 "sed -i 's/10.241.104.193:8200/127.0.0.1:8200/g' /usr/local/nginx/conf/nginx.conf"
                $ssh_tbl99 "/usr/local/nginx/sbin/nginx -s reload";;
		tbl_94_rec)
		$ssh_tbl94 "sed -i 's/10.132.9.193:23080/127.0.0.1:23080/g' /usr/local/nginx/conf/nginx.conf"
		$ssh_tbl94 "/usr/local/nginx/sbin/nginx -s reload";;
		*)
		echo "By: Xiaofeng.di@lolaage.com"
		echo " 参数"
		echo "	tblm		调整operation后台负载参数。"
		echo "	store_76_rec	恢复商城负载-76"
		echo "	store_94_rec	恢复商城负载-94"
		exit 1;;
	esac
	echo $1"负载调整完成"
}
tblm_t1(){
	case "$1" in
		start)
		$ssh_tbl99 "rm -rf /data/application/nginx_tomcat/operation_2bulu-t1/webapps/ROOT"
		$ssh_tbl99 "cp -r $tblm_ro_path/webapps/ROOT /data/application/nginx_tomcat/operation_2bulu-t1/webapps/ROOT"
		$ssh_tbl99 "/data/application/nginx_tomcat/operation_2bulu-t1/r.sh rr";;
		stop)
		$ssh_tbl99 "/data/application/nginx_tomcat/operation_2bulu-t1/r.sh s";;
		*)
		echo "By: Xiaofeng.di@lolaage.com"
		echo "	start		启动operation备用服务"
		echo "	stop		停止operation备用服务";;
	esac
}
cmd.run(){
	init_ssh
	case "$1" in
		tbl_76)
		$ssh_tbl76 $2;;
		tbl_94)
		$ssh_tbl94 $2;;
		nt_248)
		$ssh_nt248 $2;;
		ssh_nt28)
		$ssh_nt28 $2;;
		all)
		$ssh_tbl76 "$2"
		$ssh_tbl94 $2
		$ssh_nt248 $2
		$ssh_nt28 $2;;
		*)
	esac
}
crontab(){
	init_ssh
	if [ "$2" == "stop" ];then
		echo "正在停用$1计划任务..."
		case "$1" in
			tbl_76)
			$ssh_tbl76 "service crond stop";;
			tbl_94)
			$ssh_tbl94 "service crond stop";;
                        tbl_99)
                        $ssh_tbl99 "service crond stop";;
			nt_248)
			$ssh_nt248 "service crond stop";;
			ssh_nt28)
			$ssh_nt28 "service crond stop";;
                        ssh_lg229)
                        $ssh_lg229 "service crond stop";;
                        ssh_lg108)
                        $ssh_lg108 "service crond stop";;
			*)
		esac
	fi
	if [ "$2" == "start" ];then
		echo "正在启用$1计划任务..."
		case "$1" in
			tbl_76)
			$ssh_tbl76 "service crond start";;
                        tbl_99)
                        $ssh_tbl99 "service crond start";;
			tbl_94)
			$ssh_tbl94 "service crond start";;
			nt_248)
			$ssh_nt248 "service crond start";;
			ssh_nt28)
			$ssh_nt28 "service crond start";;
			*)
		esac
	fi
}
