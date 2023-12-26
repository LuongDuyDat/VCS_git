#!/bin/bash

FILE1="/var/log/checketc.log";
FILE2="/var/log/checketc2.log"

date=$(date '+%H:%M:%S %d-%m-%Y');

getFileCreated() {
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
            time_now_in_seconds=$(( ((10#$(date '+%H')*60)+10#$(date '+%M'))*60+10#$(date '+%S') ));
            if [ $(( $time_now_in_seconds - $time_in_seconds )) -le 1800 ]
            then
                head_file=$(sudo tail $file_path | tr -d '\0');
                printf "%s\n\n" $file_path;
                printf "%s\n" "$head_file";
                printf "\n";
            fi;    
            
        fi;    
        if [[ $diff -eq 1 ]]
        then
            time=$(stat $file_path | grep Birth | cut -d" " -f4 | cut -c 1-8);
            time_in_seconds=$(( ((10#$(cut -c 1-2 <<< $time)*60)+10#$(cut -c 4-5 <<< $time))*60+10#$(cut -c 7-8 <<< $time) ));
            time_now=$(date '+%H:%M:%S');
            time_now_in_seconds=$(( (($(date '+%H')*60)+$(date '+%M'))*60+$(date '+%S') ));
            if [ $(( $(( 24*60-$time_in_seconds + $time_now_inseconds  )) -le 1800 )) ]
            then
                head_file=$(sudo tail $file_path | tr -d '\0');
                printf "%s\n\n" $file_path;
                printf "%s\n" "$head_file";
                printf "\n";
            fi;
        fi;      
    done;    
}

getFileDeleted() {
    if test -f "$FILE2"; then
        file_list=$(sudo find /etc -type f | sort);
        old_file_list=$(cat "$FILE2");
        echo "$file_list" > "$FILE2";
        IFS=$'\n' read -rd '' -a file_arr <<< "$file_list";
        IFS=$'\n' read -rd '' -a old_file_arr <<< "$old_file_list";
        j=0;
        for (( i = 0; i < ${#old_file_arr[*]}; i++ ))
        do
            while [ $j -le ${#file_arr[*]} ] && [[ "${old_file_arr[i]}" > "${file_arr[j]}" ]]
            do
                j=$((j+1));
            done;
            if [ $j -gt ${#file_arr[*]} ] || [[ "${old_file_arr[i]}" < "${file_arr[j]}" ]]
            then
                echo ${old_file_arr[i]};
            fi;
        done; 
    fi;
}

file_new=$(getFileCreated);
file_change=$(sudo find /etc -type f -mmin -30);
file_delete=$(getFileDeleted)

echo "[Log checketc - $date]" > $FILE1;
echo "" >> $FILE1;
echo "=== Danh sach file tao moi ===" >> $FILE1;
echo "" >> $FILE1;
echo "$file_new" >> $FILE1;
echo "" >> $FILE1;
echo "=== Danh sach file sua doi ===" >> $FILE1;
echo "" >> $FILE1;
echo "$file_change" >> $FILE1;
echo "" >> $FILE1;
echo "=== Danh sach file bi xoa ===" >> $FILE1;
echo "" >> $FILE1;
echo "$file_delete" >> $FILE1;
echo "" >> $FILE1;
mail_content=$(cat $FILE1);
mail -s "THONG BAO FILE THAY DOI" root@localhost <<< "$mail_content";
