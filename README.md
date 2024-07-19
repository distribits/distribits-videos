# Distribits Videos

This repository contains a git-annex / DataLad dataset for video recordings from [Distribits](https://distribits.live/) 2024.

## Special remotes

There are currently no public special remotes from which the sliced videos can be obtained.

We are planning to publish the files in a public-facing location. For now, FZJ INM-7 members with access to Juseless can enable the storage with: `git annex enableremote juseless-storage url="ria+ssh://juseless.inm7.de:/data/group/psyinf/distribits/distribits.ria"` or clone directly from there (alias `#~distribits-videos`).

## Annex metadata

The information about the videos was added as [git-annex metadata](https://git-annex.branchable.com/metadata/).
This anables some cool stuff (which does not require access to file content), for example:

- show: `git annex metadata distribits2024/2024-04-04_01_welcome_day1.webm`
- search: `git annex find --metadata speaker="Joey Hess"`
- restructure directories with views, e.g.:
  - `git annex view "date=*" "title=*"`
  - `git annex view "speaker=*"`
  - (`git annex vpop` goes back to the previous view)
