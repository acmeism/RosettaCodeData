       program-id. last-sun.
       data division.
       working-storage section.
       1 wk-date.
        2 yr pic 9999.
        2 mo pic 99 value 1.
        2 da pic 99 value 1.
       1 rd-date redefines wk-date pic 9(8).
       1 binary.
        2 int-date pic 9(8).
        2 dow pic 9(4).
        2 sunday pic 9(4) value 7.
       procedure division.
           display "Enter a calendar year (1601 thru 9999): "
               with no advancing
           accept yr
           if yr >= 1601 and <= 9999
               continue
           else
               display "Invalid year"
               stop run
           end-if
           perform 12 times
               move 1 to da
               add 1 to mo
               if mo > 12              *> to avoid y10k in 9999
                   move 12 to mo
                   move 31 to da
               end-if
               compute int-date = function
                   integer-of-date (rd-date)
               if mo =12 and da = 31   *> to avoid y10k in 9999
                   continue
               else
                   subtract 1 from int-date
               end-if
               compute rd-date = function
                   date-of-integer (int-date)
               compute dow = function mod
                   ((int-date - 1) 7) + 1
               compute dow = function mod ((dow - sunday) 7)
               subtract dow from da
               display yr "-" mo "-" da
               add 1 to mo
           end-perform
           stop run
           .
       end program last-sun.
