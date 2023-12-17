import "./date" for Date

System.print("Years between 2008 and 2121 when 25th December falls on Sunday:")
for (year in 2008..2121) {
    if (Date.new(year, 12, 25).dayOfWeek == 7) System.print(year)
}
