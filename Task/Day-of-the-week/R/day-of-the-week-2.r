Also:

xmas=seq(as.Date("2008/12/25"), as.Date("2121/12/25"), by="year")
as.numeric(format(xmas[weekdays(xmas)== 'Sunday'], "%Y"))
