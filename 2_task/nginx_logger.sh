#!/bin/bash

LOG_FILE1="/var/log/nginx/custom_logfile.log"
LOG_FILE2="/var/log/nginx/custom_logfile2.log"
LOG_FILE3="/var/log/nginx/custom_logfile3.log"
LOG_FILE4="/var/log/nginx/custom_logfile4.log"

CPU_FILE="/var/www/hostnamematvey.zapto.org/html/cpu_load.txt"

NGINX_LOG="/var/log/nginx/hostnamematvey.access.log"
MAX_SIZE=307200  # 300 KB

while true; do
    #if [ -f "$LOG_FILE1" ]; then
    #    FILE_SIZE=$(stat -c%s "$LOG_FILE1")
    #    if [ "$FILE_SIZE" -gt "$MAX_SIZE" ]; then
    #        LINE_COUNT=$(wc -l < "$LOG_FILE1")
    #        > "$LOG_FILE1"  # очищаем файл
    #        echo "$(date '+%Y-%m-%d %H:%M:%S') — Очистка custom_logfile.log выполнена, удалено строк: $LINE_COUNT" >> "$LOG_FILE2"
    #    fi
    #fi

    if [ -f "$LOG_FILE1" ]; then
   	 FILE_SIZE=$(stat -c%s "$LOG_FILE1")
    
   	 if [ "$FILE_SIZE" -gt "$MAX_SIZE" ]; then
       		 TEMP_FILE=$(mktemp)
        	cp "$LOG_FILE1" "$TEMP_FILE"

		LINE_COUNT=$(wc -l < "$TEMP_FILE")

        	> "$LOG_FILE1"

        	echo "$(date '+%Y-%m-%d %H:%M:%S') — Очистка custom_logfile.log выполнена, удалено строк: $LINE_COUNT" >> "$LOG_FILE2"
        	
		rm "$TEMP_FILE"
    	fi
    fi



    tail -n 5 "$NGINX_LOG" >> "$LOG_FILE1"

    tail -n 10 "$NGINX_LOG" | awk '{ match($0, /"[^"]*" ([0-9]{3})/, arr); if (arr[1] ~ /^5[0-9][0-9]$/) print $0; }' >> "$LOG_FILE3"

    tail -n 10 "$NGINX_LOG"  | awk '{ match($0, /"[^"]*" ([0-9]{3})/, arr); if (arr[1] ~ /^4[0-9][0-9]$/) print $0; }' >> "$LOG_FILE4" 
    
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')
    echo "$CPU_USAGE" > "$CPU_FILE"

    sleep 5
done
