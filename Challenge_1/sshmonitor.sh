#!/bin/bash

getNewLoginUser() {
    logs=$(journalctl -u ssh --since "5 minute ago" | grep opened);
    IFS=$'\n' read -rd '' -a log_list <<<  "$logs";
    for (( j = 0; j < ${#log_list[*]}; j++ ))
    do
        read -a log_arr <<< "${log_list[j]}";
        date=${log_arr[0]};
        user="";
        for (( i = 1; i < ${#log_arr[*]}; i++ ))
        do
            date="$date ${log_arr[i]}";
            if [[ ${log_arr[i]} =~ ^..:..:..$ ]]
            then
                break;
            fi;
        done;
        for (( i = 1; i < ${#log_arr[*]}; i++ ))
        do
            if [[ ${log_arr[i]} = "user" ]]
            then
                user=${log_arr[i + 1]};
                break;
            fi;
        done;
        user=$(cut -d'(' -f1 <<< $user);
        printf 'User %s dang nhap thanh cong vao thoi gian %s\n' "$user" "$date";
    done;      
}

new_users=$(getNewLoginUser);

echo "[Phien dang nhap moi qua SSH]";
echo '';
echo "$new_users";
if [ "$new_users" != '' ]
then
    mail -s "THONG BAO NGUOI DUNG DANG NHAP" root@localhost <<< "$new_users";
fi;

