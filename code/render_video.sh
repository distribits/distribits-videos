set -e -u

collection_dir=$1
clip_no=$2

# read one line from clips.tsv
sed "${clip_no}q;d" "${collection_dir}/clips.tsv" | while
    IFS=$'\t' read -r source collection license date track start end name speakers title abstract;
do
    ffmpeg -y -i "${collection_dir}/${source}" \
           -ss "$start" \
           -to "$end" \
           -c:v libsvtav1 -preset 6 -svtav1-params lp=1 \
           -c:a libopus -ac 1 -ab 24k \
           "${date}_${track}_${name}.webm"

    python3 code/create_xml.py "${collection_dir}/clips.tsv" "$clip_no" "/tmp/${date}_${track}_${name}.xml"

    mkvpropedit "${collection_dir}/${date}_${track}_${name}.webm" \
                --tags "/tmp/${date}_${track}_${name}.xml"
done
