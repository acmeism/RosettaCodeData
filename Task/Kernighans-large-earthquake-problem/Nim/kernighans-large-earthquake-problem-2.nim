import strutils

for line in "data.txt".lines:
  let magnitude = line.rsplit(' ', 1)[1]
  if magnitude.parseFloat() > 6:
    echo line
