dt = list(21)
dt[1] = "abbreviated weekday name"
dt[2] = "full weekday name"
dt[3] = "abbreviated month name"
dt[4] = "full month name"
dt[5] = "Date & Time"
dt[6] = "Day of the month"
dt[7] = "Hour (24)"
dt[8] = "Hour (12)"
dt[9] = "Day of the year"
dt[10] = "Month of the year"
dt[11] = "Minutes after hour"
dt[12] = "AM or PM"
dt[13] = "Seconds after the hour"
dt[14] = "Week of the year (sun-sat)"
dt[15] = "day of the week"
dt[16] = "date"
dt[17] = "time"
dt[18] = "year of the century"
dt[19] = "year"
dt[20] = "time zone"
dt[21] = "percent sign"

for i=1 to 21
     see dt[i] + " : " + TimeList () [i] + nl
next
