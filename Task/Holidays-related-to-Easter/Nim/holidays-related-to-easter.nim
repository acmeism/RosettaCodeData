import strformat, strutils, times

const HolidayOffsets = {"Easter": 0, "Ascension": 39, "Pentecost": 49,
                        "Trinity": 56, "C/Christi": 60}


proc easterDate(year: int): DateTime =
  let a = year mod 19
  let b = year div 100
  let c = year mod 100
  let d = b div 4
  let e = b mod 4
  let f = (b + 8) div 25
  let g = (b - f + 1) div 3
  let h = (19 * a + b - d - g + 15) mod 30
  let i = c div 4
  let k = c mod 4
  let l = (32 + 2 * e + 2 * i - h - k) mod 7
  let m = (a + 11 * h + 22 * l) div 451
  let n = h + l - 7 * m + 114
  let month = n div 31
  let day = n mod 31 + 1
  result = initDateTime(day, Month(month), year, 0, 0, 0)


proc outputHolidays(year: int) =
  let edate = easterDate(year)
  stdout.write &"{year:4d}  "
  for (holiday, offset) in HolidayOffsets:
    let date = edate + initDuration(days = offset)
    let s = date.format("dd MMM").center(holiday.len)
    stdout.write &"{s}  "
  echo ""


echo "Year  Easter  Ascension  Pentecost  Trinity  C/Christi"
echo " CE   Sunday  Thursday    Sunday    Sunday   Thursday "
echo "----  ------  --------- ----------  -------  ---------"
for year in countup(400, 2100, 100): outputHolidays(year)
echo ""
for year in 2010..2020: outputHolidays(year)
