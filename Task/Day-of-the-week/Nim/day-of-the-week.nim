import times

var timeinfo = getLocalTime getTime()
timeinfo.monthday = 25
timeinfo.month = mDec
for year in 2008..2121:
  timeinfo.year = year
  if getLocalTime(timeInfoToTime timeinfo).weekday == dSun:
    stdout.write year," "
