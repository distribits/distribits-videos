set -e -u

coldir=$1
cd "$coldir"

IFS=$'\t'
while read -r source collection license date track start end name speakers title abstract; do
   echo ffmpeg -y -i "$source" \
     -ss "$start" \
     -to "$end" \
     -c:v copy -c:a copy \
     "${date}_${track}_${name}.mp4";
done < clips.tsv
