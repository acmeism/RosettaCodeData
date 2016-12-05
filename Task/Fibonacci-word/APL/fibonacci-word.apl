      F_WORD←{{⍵,,/⌽¯2↑⍵}⍣(0⌈⍺-2),¨⍵}
      ENTROPY←{-+/R×2⍟R←(+⌿⍵∘.=∪⍵)÷⍴⍵}
      FORMAT←{'N' 'LENGTH' 'ENTROPY'⍪(⍳⍵),↑{(⍴⍵),ENTROPY ⍵}¨⍵ F_WORD 1 0}
