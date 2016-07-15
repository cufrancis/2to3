#!/bin/bash


echo
echo "#############################################################"
echo "# 将2D视频转换成左右3D视频                                  #"
echo "# Intro: https://www.cufrancis.com/                         #"
echo "# Author: cufrancis <cufrancis.com@gmail.com>               #"
echo "#############################################################"
echo

path="$(cd `dirname $0`; pwd)"
# $1
movie="$path/$1"
output="$path/$2"

# 进度条
function load(){
    echo
    for i in `seq 1 20`;do
	arrow="$arrow."
	echo -e "\e[A\e[0G$[i*5]% $arrow"
	echo -e "\e[A\e[50G"
	sleep 0.02
    done
}

# Check OS
function checkos(){
    if [ -f /etc/redhat-release ];then
	OS=CentOS
    elif [ ! -z "`cat /etc/issue | grep bian`"];then
	OS=Debian
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
	OS=Ubuntu
    elif [ ! -z "`cat /etc/issue | grep Arch`" ];then
	OS=ArchLinux
    else
	echo "Not support OS, Please reinstall OS and retry!"
	exit 1
    fi	
}

# Check FFmpeg
function checkFFmpeg(){
    if command -v ffmpeg >/dev/null 2&>1;then
	echo "FFmpeg is installed!"
    else
	echo 'FFmpeg no exists, please install and retry!'
	exit 1
    fi    
}

function help(){
    echo
    echo "将2d视频转换成左右3d，耗时可能比较长\n\r"
    echo "Usage: 2to3.sh 1.mp4 2.mp4\n\r"
    echo "第一个参数为需要转换的视频，第二个参数为转换之后储存的文件名\n\r"
    echo
}

# 开始运行
# 第一个参数为原视频，第二个参数为转换后的视频文件名
function run(){
    ffmpeg -i ${movie} -vf "movie=${movie} [in1]; [in]pad=iw*2:ih:iw:0[in0]; [in0][in1] overlay=0:0 [out]" -vcodec libx264 -preset medium -b:v 1200k -r:v 25 -f mp4 $output
 #   ffmpeg -i /Users/StevenLiu/Movies/孙悟空.mp4 -vf “movie=/Users/StevenLiu/Movies/孙悟空.mp4 [in1]; [in]pad=iw*2:ih:iw:0[in0]; [in0][in1] overlay=0:0 [out]” -vcodec libx264 -preset medium -b:v 1200k -r:v 25 -f mp4 bbs.chinaffmpeg.com孙悟空.mp4
}


if [ $# != 2 ] ; then
    echo "参数不够"
    exit 1
fi
echo $path
echo $movie

echo "$#"
echo "$1"
echo "$2"

echo "Checking OS"
load
checkos
echo "OS is : "$OS
echo "Checking FFmpeg"
load
checkFFmpeg

run
