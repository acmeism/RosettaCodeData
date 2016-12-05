import: date

: lastSunday(y)
| m |
   Date.JANUARY Date.DECEMBER for: m [
      Date newDate(y, m, Date.DaysInMonth(y, m))
      while(dup dayOfWeek Date.SUNDAY <>) [ addDays(-1) ] println
      ] ;
