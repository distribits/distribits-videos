set -e -u

collection_dir=$1
clip_no=$2

# set number of threads for SVT-AV1
# use n_threads or OMP_NUM_THREADS variables if defined; otherwise 0, i.e. all available
if [[ -v n_threads ]]; then
    :
elif [[ -v OMP_NUM_THREADS ]]; then
    n_threads=$OMP_NUM_THREADS
else
    n_threads=0
fi

# read one line from clips.tsv
sed "${clip_no}q;d" "${collection_dir}/clips.tsv" | while
    IFS=$'\t' read -r source collection license date track start end name speakers title abstract;
do
    ffmpeg -y -i "${collection_dir}/${source}" \
           -ss "$start" \
           -to "$end" \
           -c:v libsvtav1 -preset 6 -svtav1-params lp="$n_threads" \
           -c:a libopus -ac 1 -ab 24k \
           "${collection_dir}/${date}_${track}_${name}.webm"

    python3 code/create_xml.py "${collection_dir}/clips.tsv" "$clip_no" "/tmp/${date}_${track}_${name}.xml"

    mkvpropedit "${collection_dir}/${date}_${track}_${name}.webm" \
                --tags "all:/tmp/${date}_${track}_${name}.xml"
done
