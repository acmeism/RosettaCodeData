from calendar import weekday, SUNDAY

[year for year in range(2008, 2122) if weekday(year, 12, 25) == SUNDAY]
