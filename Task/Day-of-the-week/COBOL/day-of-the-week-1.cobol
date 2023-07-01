       program-id. dec25.
       data division.
       working-storage section.
       1 work-date.
        2 yr pic 9(4) value 2008.
        2 mo-da pic 9(4) value 1225. *> Dec 25
       1 wk-date redefines work-date pic 9(8).
       1 binary.
        2 int-date pic 9(8).
        2 dow pic 9(4).
       procedure division.
           perform varying yr from 2008 by 1
           until yr > 2121
               compute int-date = function integer-of-date (wk-date)
               compute dow = function mod ((int-date - 1) 7) + 1
               if dow = 7  *> Sunday = 7 per ISO 8601 and ISO 1989
                   display yr
               end-if
           end-perform
           stop run
           .
       end program dec25.
