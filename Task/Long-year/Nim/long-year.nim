import times

proc has53weeks(year: Positive): bool =
  let dt = initDateTime(monthday = 1, month = mJan, year = year, hour = 0, minute = 0, second= 0)
  result = dt.weekday == dThu or year.isLeapYear and dt.weekday == dWed

when isMainModule:
  echo "Years with 53 weeks between 2000 and 2100:"
  for year in 2000..2100:
    if year.has53weeks:
      echo year
