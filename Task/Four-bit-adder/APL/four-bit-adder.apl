⍝ Our primitive "gates" are built-in, but let's give them names
not ← { ~ ⍵ }   ⍝ in Dyalog these assignments can be simplified to "not ← ~", "and ← ∧", etc.
and ← { ⍺ ∧ ⍵ }
or ← { ⍺ ∨ ⍵ }
nand ← { ⍺ ⍲ ⍵ }

⍝ Build the complex gates
xor ← { (⍺ and not ⍵) or (⍵ and not ⍺) }

⍝ And the multigate components. Our bit vectors are MSB first, so for consistency
⍝ the carry bit is returned as the left result as well.
half_adder ← { (⍺ and ⍵), ⍺ xor ⍵ } ⍝ returns carry, sum

⍝ GNU APL dfns can't have multiple statements, so the other adders are defined as tradfns
∇result ← c_in full_adder args ; c_in; a; b; s0; c0; s1; c1
 (a b) ← args
 (c0 s0) ← c_in half_adder a
 (c1 s1) ← s0 half_adder b
 result ← (c0 or c1), s1
∇

⍝ Finally, our four-bit adder
∇result ← a adder4 b ; a3; a2; a1; a0; b3; b2; b1; b0; c0; s0; c1; s1; c2; s2; s3; v
 (a3 a2 a1 a0) ← a
 (b3 b2 b1 b0) ← b
 (c0 s0) ← 0 full_adder a0 b0
 (c1 s1) ← c0 full_adder a1 b1
 (c2 s2) ← c1 full_adder a2 b2
 (v s3) ← c2 full_adder a3 b3
 result ← v s3 s2 s1 s0
∇

⍝ Add one pair of numbers and print as equation
demo ← { 0⍴⎕←⍺,'+',⍵,'=',{ 1↓⍵,' with carry ',1↑⍵ } ⍺ adder4 ⍵ }

⍝ A way to generate some random numbers for our demo
randbits ← { 1-⍨?⍵⍴2 }

⍝ And go
{ (randbits 4) demo randbits 4 ⊣ ⍵ } ¨ ⍳20
