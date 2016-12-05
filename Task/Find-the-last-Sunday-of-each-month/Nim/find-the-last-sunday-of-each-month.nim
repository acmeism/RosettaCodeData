import times, os, strutils

var timeinfo = getLocalTime getTime()
timeinfo.year = paramStr(1).parseInt
for month in mJan .. mDec:
  timeinfo.month = month
  for day in countdown(31, 1):
    timeinfo.monthday = day
    let t = getLocalTime(timeInfoToTime timeinfo)
    if t.month == month and t.weekday == dSun:
      echo t.format "yyyy-MM-dd"
      break
