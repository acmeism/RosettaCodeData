import algorithm
import unicode

type Runes = seq[Rune]

var linenum = 0
for line in lines("days.txt"):
  inc linenum
  if line.len > 0:

    # Extract the day names and store them in a sorted list of sequences of runes.
    var days: seq[Runes]
    for day in sorted(line.toLower.splitWhitespace()):
      days.add(day.toRunes)
    if days.len != 7:
      echo "Wrong number of days at line ", linenum

    # Compare the first letters of successive day names, incrementing the upper index if necessary.
    var index = 0             # Equal to abbreviation length - 1.
    var prevday = days[0]
    for idx in 1..days.high:
      let currday = days[idx]
      if currday == prevday:
        echo "Double encountered at line ", linenum
      while currday[0..min(index, currday.high)] == prevday[0..min(index, prevday.high)]:
        inc index
      prevday = currday
    echo index + 1, " ", line

  else:
    echo line
