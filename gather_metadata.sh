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

#this function is responsible for creating the thumbnails of different sizes
function createThumbnail(){
    #loop condition
    size=$1
    #get file name without extension
    fName="${2%.*}"

    #$(cut -d. -f1 <<< $2)
    #get extension
    fExtension="${2##*.}"
    #test fName and fExt are correct
    echo "$fName  $fExtension"
    #get file directory of image
    fDir=$3
    #get directory to create thumbnails to
    fDirT=$4

    while [ $size -gt 0 ]
    do
        #create new filename
        newName="$fDirT"
        newName+="/$fName"
        newName+="-$size"
        newName+=".$fExtension"
        # echo $fDir
        # echo $newName
        convert "$fDir" -resize ${size}x${size} "$newName"
        
        #decrement loop
        if [ $size -eq 512 ] ; then
            size=$(($size-256))
        else
            size=$(($size-128))
        fi
    done

}

# #main



find $dir -name ".*" -prune -o -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.jpeg -o -iname \*.tiff -o -iname \*.tif -o -iname \*.gif -o -iname \*.bmp \) | while read i;
do
    #directory where file is stored WITHOUT filename
    tempDIR=$(dirname "$i")
    #directory where .thumbs is created
    dirThumbs=$tempDIR
    dirThumbs+="/.thumbs"
    #directory where .metadata is created
    dirMetadata=$tempDIR
    dirMetadata+="/.metadata"
    #filename with extension 
    fileName=$(basename "$i")

   
    if [ ! -d "$dirThumbs" ] ; then
        mkdir $dirThumbs
    fi
    #this statement check if .metadata directory already exists
    if [ ! -d "$dirMetadata" ]; then
        mkdir $dirMetadata
    fi
    if [[ -e "$i" && ! -d "$i" ]]; then
        
        #get width
        W=$(identify -format '%w' "$i")

        #get height
        H=$(identify -format '%h' "$i")
        echo $i $W x $H $fileName
        #conditions for creating thumbnails
        if [[ $W -gt 512 || $H -gt 512 ]] ; then
            createThumbnail 512 "$fileName" "$i" $dirThumbs
        elif [[ $W -gt 256 && $W -le 512 ]] || [[ $H -gt 256 && $H -le 512 ]] ; then
            createThumbnail 256 "$fileName" "$i" $dirThumbs
        elif [[ $W -gt 128 && $W -le 256 ]] || [[ $H -gt 128 && $H -le 256 ]] ; then
            createThumbnail 128 "$fileName" "$i" $dirThumbs
        fi

        #this creates a .txt that contains the metadata of the image
        touch "$dirMetadata/$fileName.txt"
        #writes metadata of file into new .txt file
        identify -verbose "$i" > "$dirMetadata/$fileName.txt"
    fi
done




