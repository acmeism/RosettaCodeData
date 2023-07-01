import: date

: lastFridays(y)
| m |
   Date.JANUARY Date.DECEMBER for: m [
      Date newDate(y, m, Date.DaysInMonth(y, m))
      while(dup dayOfWeek Date.FRIDAY <>) [ addDays(-1) ]
      println
      ] ;
