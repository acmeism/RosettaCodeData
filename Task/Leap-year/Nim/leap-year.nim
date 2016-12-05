import times
let year = 1980
echo isLeapYear(year)

# or

proc isLeapYear2(year): bool =
  if year mod 100 == 0:
    year mod 400 == 0
  else: year mod 4 == 0

echo isLeapYear2(year)
