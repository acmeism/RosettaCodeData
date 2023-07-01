import os, strutils, times

const
  DaysInMonth: array[Month, int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  DayDiffs:  array[WeekDay, int] = [1, 2, 3, 4, 5, 6, 0]

let year = paramStr(1).parseInt

for month in mJan..mDec:
  var lastDay = DaysInMonth[month]
  if month == mFeb and year.isLeapYear: lastDay = 29
  var date = initDateTime(lastDay, month, year, 0, 0, 0)
  date = date - days(DayDiffs[date.weekday])
  echo date.format("yyyy-MM-dd")
