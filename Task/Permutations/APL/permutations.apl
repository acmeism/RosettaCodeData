⍝ Builtin version, takes a vector:
⎕CY'dfns'
perms←{↓⍵[pmat ≢⍵]} ⍝ pmat always gives lexicographically ordered permutations.

⍝ Recursive fast implementation, courtesy of dzaima from The APL Orchard:
dpmat←{1=⍵:,⊂,0 ⋄ (⊃,/)¨(⍳⍵)⌽¨⊂(⊂(!⍵-1)⍴⍵-1),⍨∇⍵-1}
perms2←{↓⍵[1+⍉↑dpmat ≢⍵]}
