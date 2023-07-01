import strscans

for line in "data.txt".lines:
  var date, name: string
  var magnitude: float
  if scanf(line, "$+ $s$+ $s$f", date, name, magnitude):
    if magnitude > 6:
      echo line
  # else wrong line: ignore.
