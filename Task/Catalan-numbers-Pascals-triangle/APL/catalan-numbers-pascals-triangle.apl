      ⍝ Based heavily on the J solution
      CATALAN←{¯1↓↑-/1 ¯1↓¨(⊂⎕IO+0 0)⍉¨0 2⌽¨⊂(⎕IO-⍨⍳N){+\⍣⍺⊢⍵}⍤0 1⊢1⍴⍨N←⍵+2}
