: fiveWeekEnd(y1, y2)
| y m |

   ListBuffer new
   y1 y2 for: y [
      Date.JANUARY Date.DECEMBER for: m [
         Date.DaysInMonth(y, m) 31 ==
         [ y, m, 01 ] asDate dayOfWeek Date.FRIDAY == and
            ifTrue: [ [ y, m ] over add ]
         ]
      ]
   dup size println dup left(5) println right(5) println ;
