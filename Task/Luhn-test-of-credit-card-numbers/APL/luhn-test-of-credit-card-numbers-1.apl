r←LuhnTest digits;even;odd;SumEven
(odd even)←↓⍉⍎¨{(n,2)⍴(⍵,'0')↑⍨2×n←⌈(⍴⍵)÷2}⌽digits
SumEven←{+/+/¨⍎¨¨⍕¨2×⍵}
r←'0'=⊃¯1↑⍕(+/odd)+(SumEven even)
