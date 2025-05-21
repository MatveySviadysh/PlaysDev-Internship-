#!/bin/bash

LOG_FILE1="/var/log/nginx/custom_logfile.log"
LOG_FILE2="/var/log/nginx/custom_logfile2.log"
LOG_FILE3="/var/log/nginx/custom_logfile3.log"
LOG_FILE4="/var/log/nginx/custom_logfile4.log"

CPU_FILE="/usr/share/nginx/html/cpu_load.txt"

NGINX_LOG="/var/log/nginx/access_file.log"
MAX_SIZE=307200  # 300 KB

while true; do
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


#    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1 "%"}')    
#    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')

    CPU_USAGE=$(awk '/^cpu / {
    idle = $5 + $6
    non_idle = $2 + $3 + $4 + $7 + $8 + $9 + $10
    total = idle + non_idle
    if (NR==1) {
        prev_total = total
        prev_idle = idle
        next
    }
    total_diff = total - prev_total
    idle_diff = idle - prev_idle
    usage = (total_diff - idle_diff) / total_diff * 100
    printf "%.2f", usage
}' <(cat /proc/stat) <(sleep 1; cat /proc/stat))

    if [ -n "$CPU_USAGE" ]; then
    echo "$CPU_USAGE" > "$CPU_FILE"
else
    echo "Ошибка вычисления CPU_USAGE" >> "$LOG_FILE2"
fi


    sleep 5
done
