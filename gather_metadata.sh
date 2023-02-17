#!/usr/bin/env bash

dir=${1:-$(pwd)}

#check directory
if [ ! -d "$dir" ] ; then
    echo "$dir is not a directory."
    exit 1 
else
    if [[ ! -r "$dir" || ! -x "$dir" ]]  ; then
        echo "$dir is not readable or executable."
        exit 1
    fi
fi

#rest
for i in $(find $dir -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.jpeg -o -iname \*.tiff -o -iname \*.tif -o -iname \*.gif -o -iname \*.bmp \))
do 
    tempDIR=$(dirname $i)
    tempDIR+="/.thumbs" 
    fileName=$(basename $i)
    echo $fileName
    if [ ! -d "$tempDIR" ] ; then
        mkdir $tempDIR
    fi
done



