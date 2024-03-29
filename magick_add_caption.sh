#!/usr/bin/env bash

# Converts filenames to utf-8 nfc normalized coding
convmv -r -f utf-8 -t utf-8 --nfc . --notest

# Displays a font warning message
echo The script uses system installed font

# Runs the caption creating loop
for f in *.png; do
    width=$(identify -format %w "$f")
    convert -font /Library/Fonts/BuenosAires-Regular.otf -background '#0008' -fill white -gravity center -size "${width}x150" caption:"${f/.png}" "$f" +swap -gravity south -composite "$f.out.png"
done

#https://legacy.imagemagick.org/Usage/annotating/
#https://imagemagick.org/script/command-line-options.php#annotate
#https://imagemagick.org/script/command-line-options.php#draw