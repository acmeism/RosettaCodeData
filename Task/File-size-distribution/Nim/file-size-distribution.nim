import math, os, strformat

const
  MaxPower = 10
  Powers = [1, 10, 100]

func powerWithUnit(idx: int): string =
  ## Return a string representing value 10^idx with a unit.
  if idx < 0:
    "0B"
  elif idx < 3:
    fmt"{Powers[idx]}B"
  elif idx < 6:
    fmt"{Powers[idx - 3]}kB"
  elif idx < 9:
    fmt"{Powers[idx - 6]}MB"
  else:
    fmt"{Powers[idx - 9]}GB"


# Retrieve the directory path.
var dirpath: string
if paramCount() == 0:
  dirpath = getCurrentDir()
else:
  dirpath = paramStr(1)
  if not dirExists(dirpath):
    raise newException(ValueError, "wrong directory path: " & dirpath)

# Distribute sizes.
var counts: array[-1..MaxPower, Natural]
for path in dirpath.walkDirRec():
  if not path.fileExists():
    continue  # Not a regular file.
  let size = getFileSize(path)
  let index = if size == 0: -1 else: log10(size.float).toInt
  inc counts[index]

# Display distribution.
let total = sum(counts)
echo "File size distribution for directory: ", dirpath
echo ""
for idx, count in counts:
  let rangeString = fmt"[{powerWithUnit(idx)}..{powerWithUnit(idx + 1)}[:"
  echo fmt"Size in {rangeString: 14} {count:>7}   {100 * count / total:5.2f}%"
echo ""
echo "Total number of files: ", sum(counts)
