       program-id. leap-yr.
           *> Given a year, where 1601 <= year <= 9999
           *> Determine if the year is a leap year
       data division.
       working-storage section.
       1 input-year pic 9999.
       1 binary.
        2 int-date pic 9(8).
        2 cal-mo-day pic 9(4).
       procedure division.
           display "Enter calendar year (1601 thru 9999): "
               with no advancing
           accept input-year
           if input-year >= 1601 and <= 9999
           then
                   *> if the 60th day of a year is Feb 29
                   *> then the year is a leap year
               compute int-date = function integer-of-day
                   ( input-year * 1000 + 60 )
               compute cal-mo-day = function mod (
                   (function date-of-integer ( int-date )) 10000 )
               display "Year " input-year space with no advancing
               if cal-mo-day = 229
                   display "is a leap year"
               else
                   display "is NOT a leap year"
               end-if
           else
               display "Input date is not within range"
           end-if
           stop run
           .
       end program leap-yr.
