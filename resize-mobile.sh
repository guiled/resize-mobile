#!/bin/bash
array_contains () { 
    local array="$1[@]"
    local seeking=$2
    local in=0
    for element in "${!array}"; do
        if [[ $element == $seeking ]]; then
            return $in
        fi
	((in++))
    done
    return -1 
}

resolutions=(ldpi mdpi hdpi xhdpi xxhdpi)
equiv=(375 500 750 1000 1500)

if [ -z $1 ]; then
	echo "Usage : $0 filename "
	exit 0
fi

res=xhdpi
if [ $2 ]; then
	res=$2
fi

dest=${1##*/}.resized
if [ $3 ]; then
	dest=$3
else
	dest=${1##*/}.resized
fi
array_contains resolutions $res
result=$?
if [[ $result -ge 255 ]]; then
	echo Uknown density. Valid densities are ${resolutions[*]}
	exit 0
fi

base=${equiv[$result]}

if ! [ -e $1 ]; then
	echo "File $1 not found"
	exit 0
fi

if ! [ -d $dest ]; then
	mkdir $dest
fi

posres=0
for newdir in "${resolutions[@]}"
do
	if ! [ -d $dest/res-$newdir ]; then
		mkdir $dest/res-$newdir
	fi
	currentres=${equiv[$posres]}
	if [[ $currentres == $base ]]; then
		`cp $1 $dest/res-$newdir/$1`
	else
		`convert $1 -resize $((currentres*100/base))% $dest/res-$newdir/$1`
	fi
	((posres++))
done
