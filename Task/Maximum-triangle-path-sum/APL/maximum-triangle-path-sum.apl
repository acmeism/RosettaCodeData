parse ← ⍎¨(~∊)∘⎕TC⊆⊢
maxpath ← ⊃(⊣+2⌈/⊢)/
⎕ ← maxpath parse ⊃⎕NGET'G:\triangle.txt'
