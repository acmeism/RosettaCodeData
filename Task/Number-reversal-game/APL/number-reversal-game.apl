∇numrev;list;in;swaps
    list←{9?9}⍣{⍺≢⍳9}⊢⍬
    swaps←0
read:
    swaps+←1
    in←{⍞←⍵⋄(≢⍵)↓⍞}(⍕list),': swap how many? '
    list←⌽@(⍳⍎in)⊢list
    →(list≢⍳9)/read
    ⎕←(⍕list),': Congratulations!'
    ⎕←'Swaps:',swaps
∇
