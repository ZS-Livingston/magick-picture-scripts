#!/bin/bash

# This script is designed to handle dates in the 21st century (2000-2099).
# If used with dates beyond 2099, the script would not format the year correctly :).

# Get the source directory
read -e -rp "Enter source directory: " -r source_directory

if [[ ! -d "$source_directory" ]]; then
    printf "Source directory %s does not exist.\n" "$source_directory"
    printf "Script exited.\n"
    exit 1
fi

# Get the first and last filenames
read -rp "Enter first file basename (include extension): " -r first_file
read -rp "Enter last file basename (include extension): " -r last_file

# Converts filenames to utf-8 nfc normalized coding
convmv -r -f utf-8 -t utf-8 --nfc "$source_directory" --notest

# Function to format date
function formatDate() {
    IFS='-' read -r month day year hourminute <<< "$1"
    IFS='.' read -r hour minute <<< "$hourminute"
    # rearrange date to required format
    echo "${day}.${month}.20${year} - ${hour}:${minute}"
}

# Loads filenames into an array
filenames=()
while IFS=  read -r -d $'\0'; do
    filenames+=("$REPLY")
done < <(find "$source_directory" -type f -name '*.jpg' -print0 | sort -z)

# Find the indices of first and last file
first_index=-1
last_index=-1
for index in "${!filenames[@]}"; do
    filename=$(basename -- "${filenames[index]}")
    if [[ "$filename" == "$first_file" ]]; then
        first_index=$index
    fi
    if [[ "$filename" == "$last_file" ]]; then
        last_index=$index
    fi
done

# If the first or last file was not found, exit
if [[ $first_index == -1 ]]; then
    printf "First file %s not found.\n" "$first_file"
    exit 1
fi
if [[ $last_index == -1 ]]; then
    printf "Last file %s not found.\n" "$last_file"
    exit 1
fi

# Modify the images in the range
for ((index=first_index; index<=last_index; index++)); do
    f="${filenames[index]}"
    base=$(basename "$f" .jpg)
    formattedDate=$(formatDate "$base")
    convert "$f" -font /Library/Fonts/BuenosAires-Regular.otf -pointsize 45 -fill white -gravity northwest -annotate +10+10 "$formattedDate" "${f}"
done
