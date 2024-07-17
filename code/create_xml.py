import argparse
import csv
from itertools import islice
from pathlib import Path
import xml.etree.ElementTree as ET

def subelement_with_text(parent, tag, text):
    """Create an element with text and add it to parent"""
    sub = ET.SubElement(parent, tag)
    sub.text = text
    return sub

def simpleTag(name, s):
    """Create a Simple tag with given name and string"""
    tag = ET.Element("Simple")
    tag_name = subelement_with_text(tag, "Name", name)
    tag_string = subelement_with_text(tag, "String", s)
    return tag

def targetsTag(targetTypeValue):
    """Create Targets tag with a given TargetTypeValue"""
    tag = ET.Element("Targets")
    _ = subelement_with_text(tag, "TargetTypeValue", str(targetTypeValue))
    return tag


parser = argparse.ArgumentParser()
parser.add_argument("clip_list", type=Path, help="A tsv file with clip metadata")
parser.add_argument("line", type=int, help="Number of line to use (1-based)")
parser.add_argument("output_file", type=Path, help="Output XML file")
args = parser.parse_args()

tsvpath = args.clip_list
line_idx = args.line - 1
xmlpath = args.output_file

with tsvpath.open("rt") as tsvfile:
    # read entered metadata
    reader = csv.reader(tsvfile, delimiter="\t")
    row = next(islice(reader, line_idx, line_idx+1))

    (
        source,
        collection,
        license,
        date,
        track,
        start,
        end,
        name,
        speakers,
        title,
        abstract,
    ) = row


# rewrite cc-by to canonical URL; assuming all use CC-BY-3.0
assert license == "CC-BY-3.0"
copyright = f"Distribits 2024 {license}"
license = "https://creativecommons.org/licenses/by/3.0/"

# https://matroska.org/technical/tagging.html

root = ET.Element("Tags")

# movie (album) tags
movie_tags = ET.SubElement(root, "Tag")
movie_tags.extend((targetsTag(50), simpleTag("TITLE", collection)))

# chapter (track) tags
# note: combining speakers into one artist tag to fit vlc
chapter_tags = ET.SubElement(root, "Tag")
chapter_tags.extend(
    (
        targetsTag(30),
        simpleTag("TITLE", title),
        simpleTag("ARTIST", speakers),
        simpleTag("PART_NUMBER", str(int(track))),
        simpleTag("DATE_RECORDED", date),
        simpleTag("LICENSE", license),
        simpleTag("COPYRIGHT", copyright),
    )
)

# save pretty-printed xml
tree = ET.ElementTree(root)
ET.indent(tree)
with xmlpath.open("wt") as f:
    tree.write(f, encoding="unicode", xml_declaration=True)
