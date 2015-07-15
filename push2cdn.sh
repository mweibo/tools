#!/usr/bin/env bash
###########################
# Example:
# 	push2cdn
# 		增量推送文件到cdn
# 	push2cdn -a 
# 		推送所有文件到cdn
# Usage:
#	-a 
#		推送所有文件
# 	-m <module> 
#		模块名
###########################
set -o errexit;
src=src_dir
src=${src%/}
fileNum=20; # 每次分发文件数:20
module='h5_sinaimg_m'; # 默认module
all=false;

# parse param
while test $# -gt 0; do
	case "$1" in 
		-a) all=true;;
		-m) module="$2"; shift;;
	esac;
	shift
done

function pushcdn(){
	echo curl -d module="$1" -d files="$2" -d pad="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "http://small-pool.sina.com.cn:8080/publish" -v 
	curl -d module="$1" -d files="$2" -d pad="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" "http://small-pool.sina.com.cn:8080/publish" -v 
}

# Create src;
test -d $src || mkdir -p $src;

# pullRsync
filelist=`rsync -avzn --port=8705 10.13.130.60::$module $src`;
rsync -avz --port=8705 10.13.130.60::$module $src;

# pushRsync
rsync -avz  --port=873 $src/ small-pool.sina.com.cn::h5_sinaimg_m/

# diffcmd
declare -i i=0;
declare -i j=0;
if [[ "$all" = 'true' ]]; then
	#cmd='find $src -type f | cut -c `let n=${#src}+2; echo -n $n`- ';
	cmd='find $src -type f | cut -c `echo $((${#src}+2))`- ';
else
	cmd='printf "%s" "$filelist"';
fi

while read line; do 
	file="$src/$line";
	if [[ "$file" =~ ^[[:digit:]_./[:alpha:]]+$ ]] && [[ -f "$file" ]];then
		md5=`md5sum $file | awk '{print $1}'`;
		relative_file=${file#$src/}
		files+=`echo -ne "\n$relative_file\t$md5"`
		let ++i;
		if [[ $i -eq $fileNum ]];then
			pushcdn $module "$files";
			i=0;
			files='';
		fi
	fi
done < <(eval "$cmd") ;
[[ -n "$files" ]] && pushcdn $module "$files";
