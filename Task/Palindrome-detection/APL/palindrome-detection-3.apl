inexact←{Aa←(⎕A,⎕a) ⋄ (⊢≡⌽)(⎕a,⎕a)[Aa⍳⍵/⍨⍵∊Aa]}
      inexact 'abc,-cbA2z'
0
      inexact 'abc,-cbA2'
1
