# Distribits Videos

This repository contains a git-annex / DataLad dataset for video recordings from [Distribits](https://distribits.live/) 2024.

## Annex metadata

The information about the videos was added as [git-annex metadata](https://git-annex.branchable.com/metadata/).
This anables some cool stuff (which does not require access to file content), for example:

- show: `git annex metadata distribits2024/2024-04-04_01_welcome_day1.webm`
- search: `git annex find --metadata speaker="Joey Hess"`
- restructure directories with views, e.g.:
  - `git annex view "date=*" "title=*"`
  - `git annex view "speaker=*"`
  - (`git annex vpop` goes back to the previous view)

## Data availability

The file contents have been initially published to:

- (public) https://hub.datalad.org/distribits/recordings
- (private) `ria+ssh://juseless.inm7.de:/data/group/psyinf/distribits/distribits.ria` (alias `#~distribits-videos`)

When cloning from hub.datalad.org, no additional configuration is required. Otherwise, enable as needed.
