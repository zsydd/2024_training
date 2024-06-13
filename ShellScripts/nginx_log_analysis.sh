#!/bin/bash

# MySQL 配置
MYSQL_HOST="192.168.72.129"
MYSQL_USER="root"
MYSQL_PASS="QP984333zsy."
MYSQL_DB="ilovexiaomi"
MYSQL_TABLE="nginx_log_stats"

# Nginx 日志文件路径
LOG_FILE="/var/log/nginx/access.log"

# 获取当前时间和一分钟前的时间戳
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")
ONE_MINUTE_AGO=$(date --date="1 minute ago" +"%d/%b/%Y:%H:%M")

# 统计每秒的请求数 (QPS) 以及 HTTP 状态码为 200 和 500+ 的数量
QPS=$(grep "$ONE_MINUTE_AGO" $LOG_FILE | wc -l)
HTTP_200=$(grep "$ONE_MINUTE_AGO" $LOG_FILE | grep ' 200 ' | wc -l)
HTTP_500=$(grep "$ONE_MINUTE_AGO" $LOG_FILE | grep ' 50[0-9] ' | wc -l)

# 将统计结果保存到 MySQL 数据库
mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DB <<EOF
INSERT INTO $MYSQL_TABLE (timestamp, qps, http_200, http_500)
VALUES ('$CURRENT_TIME', '$QPS', '$HTTP_200', '$HTTP_500');
EOF