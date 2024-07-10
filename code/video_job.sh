#! /bin/bash
set -e -u

# input parameter(s)
clip_no=$1

# parameters to be read from the environment variables
# $collection_dir  - directory with video files and clips.tsv
# $dssource        - URL for DataLad clone
# $storage_name    - name of special remote to pull / push
# $dslockfile      - lock file for push, should be accessible to all jobs

datalad clone $dssource /tmp/distribits-videos
cd /tmp/distribits-videos

# create and check out clip-specific branch
git branch "clip-${clip_no}"
git switch "clip-${clip_no}"

# read input and output file from the tsv to have explicit i/o for datalad run
# columns: *source* collection license *date* *track* start end *name* speakers title abstract
input_file=$(awk -F '\t' -v row=$clip_no 'NR==row {print $1}' < "${collection_dir}/clips.tsv")
output_file=$(awk -F '\t' -v row=$clip_no 'NR==row {print $4 "_" $5 "_" $8 ".webm"}' < "${collection_dir}/clips.tsv")

datalad containers-run \
        -m "Convert ${output_file}" \
        -n "converter" \
        --explicit \
        -o "${collection_dir}/${output_file}" \
        -i "${collection_dir}/clips.tsv" \
        -i "${collection_dir}/${input_file}" \
        -i "${collection_dir}/.metadata/${output_file%.webm}.xml" \
        bash code/render_video.sh $collection_dir $clip_no

# push result file content first - does not need a lock, no interaction with Git
datalad push --to $storage_name
# and the output branch next - needs a lock to prevent concurrency issues
# the lock file should be accessible to all jobs
flock --verbose $dslockfile git push origin
