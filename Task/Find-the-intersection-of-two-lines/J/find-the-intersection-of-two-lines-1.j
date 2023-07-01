det=: -/ .*   NB. calculate determinant
findIntersection=: (det ,."1 [: |: -/"2) %&det -/"2
