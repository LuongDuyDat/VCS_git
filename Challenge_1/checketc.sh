#!/bin/bash

date=$(date '+%H:%M:%S %d-%m-%Y');

getFileChanged() {
    file_list=$(sudo find /etc -type f -cmin -30);
    for file_path in $file_list
    do
        date=$(stat $file_path | grep Birth | cut -d" " -f3);
        now_date=$(date '+%F');
        if [ $date = $now_date ]
        then
            time=$(stat $file_path | grep Birth | cut -d" " -f4 | cut -c 1-8);
            time_in_seconds=$(( ((10#$(cut -c 1-2 <<< $time)*60)+10#$(cut -c 4-5 <<< $time))*60+10#$(cut -c 7-8 <<< $time) ));
            time_now=$(date '+%H:%M:%S');
            time_now_in_seconds=$(( (($(date '+%H')*60)+$(date '+%M'))*60+$(date '+%S') ));
            if [ $(( $(( $time_now_in_seconds - $time_in_seconds )) <= 1800 )) ]
            then
                printf "%s\n\n" $file_path;
                printf "%s\n" "$(sudo tail $file_path)";
                printf "\n";
            fi;    
            
        fi;    
    done;    
}

file_new=$(getFileChanged);
file_change=$(sudo find /etc -type f -mmin -30);

echo "[Log checketc - $date]";
echo "";
echo "=== Danh sach file tao moi ===";
echo "";
echo "$file_new";
echo "=== Danh sach file sua doi ===";
echo "";
echo "$file_change";
echo "";
echo "=== Danh sach file bi xoa ===";
echo "";
echo "$file_change";
echo "";