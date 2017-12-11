#!/bin/bash
fg_log(){
        T_DATE_FILE_NEW_1=`echo $1 | awk -F '.' '{print $1}'`
        T_DATE_FILE_NEW_2=`echo $1 | awk -F '.' '{print $2}'`
        T_DATE_FILE_NEW=$T_DATE_FILE_NEW_1'-'`date +%F`'.'$T_DATE_FILE_NEW_2
        cp $1 $T_DATE_FILE_NEW
        echo '' > $1
}
fg_log /data/logs/access_file.log
