#!/bin/sh


DIR=$2
FIND=$1
REPLACE=$3

if [ $# -ne 3 ]; then
    echo "Wrong params. <find><dir><replace>"
    exit 1
fi

F=(`grep -rl "${1}" ${2}`)
echo Found ${#F[@]} files:

for d in ${F[@]};do
    echo " --> "${d}
done

if (( ${#F[@]} == 0 )); then
    echo "No results found. Exiting"
    exit 0
fi

echo "Proceed? y/n"
read resp

if [ "$resp" == "y" ];then
    for d in ${F[@]};do
        echo "Changing $1 to $3 to file ${d}"
        sed -i -e "s/${1}/${3}/g" ${d}
    done
elif [ "$resp" == "n" ]; then
    exit 0
else
    echo "wrong command"
    exit 1
fi
