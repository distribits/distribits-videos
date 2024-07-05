set -e -u

coldir=$1
cd "$coldir"

IFS=$'\t'

while read -r source collection license date track start end name speakers title abstract; do
   ffmpeg -y -i "$source" \
     -ss "$start" \
     -to "$end" \
     -c:v libsvtav1 -c:a copy -svtav1-params keyint=150 \
     -metadata "album=$collection" \
     -metadata "artist=$speakers" \
     -metadata "title=$title" \
     -metadata "track=$track" \
     -metadata "date=$date" \
     -metadata "language=en" \
     -metadata "copyright=$license" \
     -metadata "description=$abstract" \
     "${date}_${track}_${name}.mkv";
   exit
done < clips.tsv
