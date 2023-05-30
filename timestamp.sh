#!/usr/bin/env bash

# This script is designed to handle dates in the 21st century (2000-2099).
# If used with dates beyond 2099, the script would not format the year correctly :).

# Converts filenames to utf-8 nfc normalized coding
convmv -r -f utf-8 -t utf-8 --nfc . --notest

# Displays a font warning message
echo The script uses system installed font

# Function to format date
function formatDate() {
    IFS='-' read -r month day year hourminute <<< "$1"
    IFS='.' read -r hour minute <<< "$hourminute"
    # rearrange date to required format
    echo "${day}.${month}.20${year} - ${hour}:${minute}"
}

# Runs the caption creating loop
for f in *.jpg; do
    base=$(basename "$f" .jpg)
    formattedDate=$(formatDate "$base")
    convert "$f" -font /Library/Fonts/BuenosAires-Regular.otf -pointsize 45 -fill white -gravity northwest -annotate +10+10 "$formattedDate" "${f}"
done

#https://legacy.imagemagick.org/Usage/annotating/
#https://imagemagick.org/script/command-line-options.php#annotate
#https://imagemagick.org/script/command-line-options.php#draw
