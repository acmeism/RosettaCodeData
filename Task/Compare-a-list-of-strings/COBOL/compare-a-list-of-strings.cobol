       identification division.
       program-id. CompareLists.

       data division.
       working-storage section.
       78  MAX-ITEMS              value 3.
       77  i                      pic 9(2).
       01  the-list.
           05 list-items occurs MAX-ITEMS.
              10 list-item        pic x(3).
       01  results.
           05 filler              pic 9(1).
              88 equal-strings    value 1 when set to false is 0.
           05 filler              pic 9(1).
              88 ordered-strings  value 1 when set to false is 0.

       procedure division.
       main.
           move "AA BB CC" to the-list
           perform check-list
           move "AA AA AA" to the-list
           perform check-list
           move "AA CC BB" to the-list
           perform check-list
           move "AA ACBBB CC" to the-list
           perform check-list
           move "AA" to the-list
           perform check-list
           stop run
           .
       check-list.
           display "list:"
           set equal-strings to true
           set ordered-strings to true
           perform varying i from 1 by 1 until i > MAX-ITEMS
              if list-item(i) <> spaces
                 display function trim(list-item(i)), " " no advancing
                 if i < MAX-ITEMS and list-item(i + 1) <> spaces
                    if list-item(i + 1) <> list-item(i)
                       set equal-strings to false
                    end-if
                    if list-item(i + 1) <= list-item(i)
                       set ordered-strings to false
                    end-if
                 end-if
              end-if
           end-perform
           display " "
           if equal-strings
              display "... is lexically equal"
           else
              display "... is not lexically equal"
           end-if
           if ordered-strings
              display "... is in strict ascending order"
           else
              display "... is not in strict ascending order"
           end-if
           display " "
           .
