$$ MODE TUSCRIPT
files=FILE_NAMES (+,-std-)
fileswtxt= FILTER_INDEX (files,":*.txt:",-)
txtfiles= SELECT (files,#fileswtxt)
