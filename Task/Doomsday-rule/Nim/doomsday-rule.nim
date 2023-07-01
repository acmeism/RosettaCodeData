import strformat, times

const
  NormDoom = [1: 3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5]
  LeapDoom = [1: 4, 1, 7, 2, 4, 6, 4, 1, 5, 3, 7, 5]

proc weekday(year, month, day: int): WeekDay =
  let doom = (2 + 5 * (year mod 4) + 4 * (year mod 100) + 6 * (year mod 400)) mod 7
  let anchor = if year.isLeapYear: LeapDoom[month] else: NormDoom[month]
  let wd = (doom + day - anchor + 7) mod 7
  result = if wd == 0: dSun else: WeekDay(wd - 1)

const Dates = ["1800-01-06", "1875-03-29", "1915-12-07",
               "1970-12-23", "2043-05-14", "2077-02-12", "2101-04-02"]

for date in Dates:
  let dt = date.parse("yyyy-MM-dd")
  let wday = weekday(dt.year, ord(dt.month), dt.monthday)
  if wday != dt.weekday:
    echo &"For {date}, expected {dt.weekday}, found {wday}."
  else:
    echo date, " → ", wday
