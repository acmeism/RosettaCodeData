load "stdlib.ring"

DaysBetween = [["1995-11-21","1995-11-21"],
               ["2019-01-01","2019-01-02"],
               ["2019-01-02","2019-01-01"],
               ["2019-01-01","2019-03-01"],
               ["2020-01-01","2020-03-01"],
               ["1902-01-01","1968-12-25"],
               ["2090-01-01","2098-12-25"]]

for n = 1 to len(DaysBetween)
    date1 = DaysBetween[n][1]
    date2 = DaysBetween[n][2]
    date3 = substr(date1,9,2) + "/" + substr(date1,6,2) + "/" + substr(date1,1,4)
    date4 = substr(date2,9,2) + "/" + substr(date2,6,2) + "/" + substr(date2,1,4)
    ? "Days between " + DaysBetween[n][1] + " and " + DaysBetween[n][2] + ": " + diffdays(date4,date3)
next
