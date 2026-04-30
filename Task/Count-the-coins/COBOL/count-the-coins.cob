       identification division.
       program-id. CountCoins.

       data division.
       working-storage section.
       77  i                      pic 9(3).
       77  j                      pic 9(3).
       77  m                      pic 9(3) value 4.
       77  n                      pic 9(3) value 100.
       77  edited-value           pic z(18).
       01  coins-table            value "01051025".
           05 coin                pic 9(2) occurs 4.
       01  ways-table.
           05 way                 pic 9(18) occurs 100.

       procedure division.
       main.
           perform calc-count
           move way(n) to edited-value
           display function trim(edited-value)
           stop run
           .
       calc-count.
           initialize ways-table
           move 1 to way(1)
           perform varying i from 1 by 1 until i > m
              perform varying j from coin(i) by 1 until j > n
                 add way(j - coin(i)) to way(j)
              end-perform
           end-perform
           .
