       program-id. five-we.
       data division.
       working-storage section.
       1 wk binary.
        2 int-date pic 9(8).
        2 dow pic 9(4).
        2 friday pic 9(4) value 5.
        2 mo-sub pic 9(4).
        2 months-with-5 pic 9(4) value 0.
        2 years-no-5 pic 9(4) value 0.
        2 5-we-flag pic 9(4) value 0.
         88 5-we-true value 1 when false 0.
       1 31-day-mos pic 9(14) value 01030507081012.
       1 31-day-table redefines 31-day-mos.
        2 mo-no occurs 7 pic 99.
       1 cal-date.
        2 yr pic 9(4).
        2 mo pic 9(2).
        2 da pic 9(2) value 1.
       procedure division.
           perform varying yr from 1900 by 1
           until yr > 2100
               set 5-we-true to false
               perform varying mo-sub from 1 by 1
               until mo-sub > 7
                   move mo-no (mo-sub) to mo
                   compute int-date = function
                       integer-of-date (function numval (cal-date))
                   compute dow = function mod
                       ((int-date - 1) 7) + 1
                   if dow = friday
                       perform output-date
                       add 1 to months-with-5
                       set 5-we-true to true
                   end-if
               end-perform
               if not 5-we-true
                   add 1 to years-no-5
               end-if
           end-perform
           perform output-counts
           stop run
           .

       output-counts.
           display "Months with 5 weekends: " months-with-5
           display "Years without 5 weekends: " years-no-5
           .

       output-date.
           display yr "-" mo
           .
       end program five-we.
