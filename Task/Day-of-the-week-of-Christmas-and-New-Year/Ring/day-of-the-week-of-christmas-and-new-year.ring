? "working..."
weekdays = ["Mon","Tues","Wednes","Thurs","Fri","Satur","Sun"]
dow = timelist()[15]
today = date()
tycd = "25/12/" + substr(today, 7, 4)
nnyd = "01/01/" + string(number(substr(today, 7, 4)) + 1)
for day = 0 to 366
  anotherday = adddays(today, day)
  if anotherday = tycd
    ? "This year's Christmas day is on a " + nameof(day) + "."
  ok
  if anotherday = nnyd
    ? "The next New Year's day is on a " + nameof(day) + "."
    exit
  ok
next
put "done..."

func nameof day
    return weekdays[((day + today - 1) % 7) + 1] + "day"
