enc ← {⎕IO←0 ⋄ 0=≢⍵:⍵ ⋄ (⍺⍳c),(c,⍺~c←⊃⍵)∇1↓⍵}
dec ← {⎕IO←0 ⋄ 0=≢⍵:0↑⍺ ⋄ c,(c,⍺~c←(⊃⍵)⊃⍺)∇1↓⍵}
show ← {az←⎕C⎕A ⋄ e←az enc ⍵ ⋄ d←az dec e ⋄ ⍵≡d:⍵,' → ',(⍕e),' → ',d ⋄ 'Error'⎕SIGNAL 16}
↑show¨ 'broood' 'bananaaa' 'hiphophiphop'
