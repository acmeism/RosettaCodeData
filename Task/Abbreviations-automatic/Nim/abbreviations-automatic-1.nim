import sets
import unicode

type Runes = seq[Rune]

var linenum = 0
for line in lines("days.txt"):
  inc linenum
  if line.len > 0:

    # Extract the day names and store them in a sorted list of sequences of runes.
    var days: seq[Runes]
    for day in line.splitWhitespace():
      days.add(day.toLower.toRunes)
    if days.len != 7:
      echo "Wrong number of days at line ", linenum

    # Build the abbreviations and store them in a set.
    var index = 0
    while true:
      var abbrevs: HashSet[seq[Rune]]
      for day in days:
        abbrevs.incl(day[0..min(index, day.high)])
      if abbrevs.card == 7:
        # All abbreviations are different: fine!
        break
      inc index
    echo index + 1, " ", line

  else:
    echo line
