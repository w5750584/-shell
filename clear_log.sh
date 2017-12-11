#!/bin/bash
remove_tomcat_log(){
        rm -f `find $1 -atime +3`
}
remove_java_log(){
        rm -f `find $1 -name "*.out" -atime +3`
}
remove_nginx_log(){
        rm -f `find $1 -atime +3 | grep [0-9]`
}
echo '' > /data/sh/log/processlist_status.log
remove_nginx_log /data/logs/
remove_tomcat_log $tbl_log
remove_tomcat_log $file_log
remove_tomcat_log $jy_log
remove_tomcat_log $store_log
remove_tomcat_log $pgy_log
remove_java_log $helper_log
