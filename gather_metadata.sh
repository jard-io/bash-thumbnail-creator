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
echo "$(find $dir -type f \( -iname \*.jpg -o -iname \*.png \))"
echo "this is $dir"