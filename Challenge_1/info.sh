#!/bin/bash

getRam() {
    local ram=$(free -m | grep "Mem" | tr -s ' ');
    read -a arr <<< "$ram";
    echo ${arr[1]}
}

getStorageFreeSpace() {
    local storage=$(df -m | tr -s ' ');
    IFS=$'\n' read -rd '' -a arr <<< "$storage";
    total=0;
    for (( i = 1; i < ${#arr[*]}; i++ ))
    do
        IFS=' ' read -a space_arr <<< "${arr[$i]}";
        total=$(($total + ${space_arr[3]}));
    done;    
    echo $total;
}

getDirectory() {
    local directories=$(sudo find "$PWD" / -maxdepth 2 -type d 2>/dev/null);
    IFS=$'\n' read -rd '' -a d_arr <<< "$directories";
    for (( i = 0; i < ${#d_arr[*]}; i++ ))
    do
        priviledge=$(sudo ls -ld ${d_arr[i]} 2>/dev/null | tr -s ' ' | cut -d' ' -f1);
        if [[ $priviledge =~ d......rw. ]]; then
            echo ${d_arr[i]};
        fi;    
    done;    
}

name=$(hostname);
osname=$(cut -c 19- <<< $(hostnamectl | grep "Operating System"));

cpuname=$(cut -c 13- <<< $(lscpu | grep "Model name"  | tr -s ' '));
cpuarchitecutre=$(cut -c 15- <<< $(lscpu | grep "Architecture" | tr -s ' '));

ram=$(getRam);
free_storage=$(getStorageFreeSpace);

ip_list=$(ip a | grep "inet");

user_list=$(cut -d: -f1 /etc/passwd | sort);

root_processes=$(ps -U root -u root u --sort cmd);

open_ports=$(netstat -tulpn);

d_list=$(getDirectory);

echo "[Thong tin he thong]";
echo '';
echo $name;
echo $osname;
echo $cpuname;
echo $cpuarchitecutre;
echo $ram;
echo $free_storage;
echo "Danh sach dia chi ip cua he thong: ";
printf "%s$ip_list\n";
echo "Danh sach user tren he thong: ";
printf "%s$user_list\n";
echo "Thong tin cac tien trinh đang chay voi quyen root: "
echo "$root_processes";
echo "Thong tin cac port dang mo: ";
echo "$open_ports";
echo "Danh sach cac thu muc tren he thong cho phep other có quyen ghi";
echo "$d_list";