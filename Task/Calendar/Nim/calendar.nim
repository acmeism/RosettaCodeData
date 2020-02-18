import times
import strformat

proc printCalendar(year, nCols: int) =
  var rows = 12 div nCols
  var date = initDateTime(1, mJan, year, 0, 0, 0, utc())
  if rows mod nCols != 0:
    inc rows
  var offs = getDayOfWeek(date.monthday, date.month, date.year).int
  var mons: array[12, array[8, string]]
  for m in 0..11:
    mons[m][0] = &"{$date.month:^21}"
    mons[m][1] = " Su Mo Tu We Th Fr Sa"
    var dim = getDaysInMonth(date.month, date.year)
    for d in 1..42:
      var day = d > offs and d <= offs + dim
      var str = if day: &" {d-offs:2}" else: "   "
      mons[m][2 + (d - 1) div 7] &= str
    offs = (offs + dim) mod 7
    date = date + months(1)
  var snoopyString, yearString: string
  formatValue(snoopyString, "[Snoopy Picture]", "^" & $(nCols * 24 + 4))
  formatValue(yearString, $year, "^" & $(nCols * 24 + 4))
  echo snoopyString, "\n" , yearString, "\n"
  for r in 0..<rows:
    var s: array[8, string]
    for c in 0..<nCols:
      if r * nCols + c > 11:
        break
      for i, line in mons[r * nCols + c]:
        s[i] &= &"   {line}"
    for line in s:
      if line == "":
        break
      echo line
    echo ""

printCalendar(1969, 3)
