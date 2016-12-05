      ENTROPY←{-+/R×2⍟R←(+⌿⍵∘.=∪⍵)÷⍴⍵}

      ⍝ How it works:
      ⎕←UNIQUE←∪X←'1223334444'
1234
      ⎕←TABLE_OF_OCCURENCES←X∘.=UNIQUE
1 0 0 0
0 1 0 0
0 1 0 0
0 0 1 0
0 0 1 0
0 0 1 0
0 0 0 1
0 0 0 1
0 0 0 1
0 0 0 1
      ⎕←COUNT←+⌿TABLE_OF_OCCURENCES
1 2 3 4
      ⎕←N←⍴X
10
      ⎕←RATIO←COUNT÷N
0.1 0.2 0.3 0.4
      -+/RATIO×2⍟RATIO
1.846439345
