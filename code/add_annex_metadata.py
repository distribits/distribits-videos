import argparse
import csv
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument("clip_list", type=Path, help="A tsv file with clip metadata")
args = parser.parse_args()

columns = ("source", "collection", "license", "date", "track", "start", "end", "name", "speakers", "title", "abstract")

with args.clip_list.open("rt") as tsvfile:
    # read metadata table
    reader = csv.DictReader(tsvfile, fieldnames=columns, delimiter="\t")
    for row in reader:
        arg_list = []
        for colname in columns:
            if colname in ("source", "start", "end"):
                # skip technical metadata used for cutting
                pass
            elif colname == "speakers":
                # git annex can handle multiple values for a key
                speakers = row["speakers"].split(",")
                for speaker in speakers:
                    arg_list.extend(["--set", f"speaker+={speaker.lstrip()}"])
            else:
                # any regular field
                v = row[colname]
                arg_list.extend(["--set", f"{colname}={row[colname]}"])

        # figure out which file we should add metadata to
        webmfile = (
            args.clip_list.parent / f"{row['date']}_{row['track']}_{row['name']}.webm"
        )

        # run git annex metadata
        subprocess.run(["git", "annex", "metadata", *arg_list, webmfile])
