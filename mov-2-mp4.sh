#!/usr/bin/env bash


# Variables
root_folder="/mnt/nextcloud/"                                      # Where to scan
installation_path="/var/www/nextcloud/public_html"  # Full path where nextcloud is installed, must not end with '/'
old_extension=".mov"                                               # e.g. ".mov"
new_extension=".mp4"                                               # e.g. ".mp4"
safe_mode=true                                                     # true = rename file to .mov-old, false = permanently delete old .mov file
ignoregrep="DfsrPrivate"                                           # Ignore stderr messages from find that match this grep (e.g. 'Permission denied' for some folder name)


# Find files to convert
files_to_convert=()
while IFS=  read -r -d $'\0'; do
    files_to_convert+=("$REPLY")
done < <(find $root_folder -name "*$old_extension" -print0 2> >(grep -v $ignoregrep >&2))


# Get list of folders to update and remove duplicates
folders_to_update=()
for i in "${files_to_convert[@]}"
do
        :
        printf "Processing $i\n\n"
        xpath=${i%/*}
        folders_to_update+=("${xpath:${#root_folder}}") # discard everything after root folder (cuts by length of string)
done
eval folders_to_update=($(for i in  "${folders_to_update[@]}" ; do  echo "\"$i\"" ; done | sort -u))


# Convert it!
for i in "${files_to_convert[@]}"
do
        :
        ffmpeg -loglevel panic -i "$i" -q:v 0 -q:a 0 "${i::-${#old_extension}}$new_extension"
        if [ "$safe_mode" = true ]
                then
                        mv "$i" "$i-old"
                else
                rm "$i"
        fi
done


# Update folders
for i in "${folders_to_update[@]}"
do
        :
        php $installation_path/occ files:scan --path="$i"
done
