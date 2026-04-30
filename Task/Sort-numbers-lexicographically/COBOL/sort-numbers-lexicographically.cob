       identification division.
       program-id. LexicographicalNumbers.

       data division.
       working-storage section.
       78  MAX-NUMBERS            value 21.
       77  i                      pic 9(2).
       77  edited-number          pic z(2).

       01  lex-table.
           05 table-itms occurs MAX-NUMBERS.
              10 number-lex       pic x(2).

       procedure division.
       main.
      *>-> Load numbers
           perform varying i from 1 by 1 until i > MAX-NUMBERS
              move i to edited-number
              move edited-number to number-lex(i)
              call "C$JUSTIFY" using number-lex(i), "Left"
           end-perform

      *>-> Sort in lexicographic order
           sort table-itms ascending number-lex

      *>-> Show ordered numbers
           display "[" no advancing
           perform varying i from 1 by 1 until i > MAX-NUMBERS
              display function trim(number-lex(i)) no advancing
              if i < MAX-NUMBERS
                 display ", " no advancing
              end-if
           end-perform
           display "]"
           stop run
           .
