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

name=$(hostname);
osname=$(cut -c 19- <<< $(hostnamectl | grep "Operating System"));

cpuname=$(cut -c 13- <<< $(lscpu | grep "Model name"  | tr -s ' '));
cpuarchitecutre=$(cut -c 15- <<< $(lscpu | grep "Architecture" | tr -s ' '));

ram=$(getRam);
free_storage=$(getStorageFreeSpace);

ip_list=$(ip a | grep "inet" | sed 's/^[[:space:]]*//');

user_list=$(cut -d: -f1 /etc/passwd | sort);

root_processes=$(ps -U root -u root u --sort cmd);

open_ports=$(netstat -tulpn);

d_list=$(find / -type d -perm -o=w 2>/dev/null);

dpkg_list=$(dpkg -l);
apt_list=$(apt list --installed);
snap_list=$(snap list);

echo "[Thong tin he thong]";
echo '';
echo "Ten may: $name";
echo "Ten ban phan phoi: $osname";
echo "Ten CPU: $cpuname";
echo "Thong tin CPU: $cpuarchitecutre";
echo "Dung luong bo nho vat ly: $ram MiB";
echo "O dia con trong: $free_storage MiB";
echo "Danh sach dia chi ip cua he thong: ";
printf "%s$ip_list\n";
echo "Danh sach user tren he thong: ";
printf "%s$user_list\n";
echo "Thong tin cac tien trinh đang chay voi quyen root: "
echo "$root_processes";
echo "Thong tin cac port dang mo: ";
echo "$open_ports";
echo "Danh sach cac thu muc tren he thong cho phep other có quyen ghi:";
echo "$d_list";
echo "Danh sach cac goi phan mem duoc cai dat tren he thong boi dpkg:";
echo "$dpkg_list";
echo "Danh sach cac goi phan mem duoc cai dat tren he thong boi apt:";
echo "$apt_list";
echo "Danh sach cac goi phan mem duoc cai dat tren he thong boi snap:";
echo "$snap_list";
