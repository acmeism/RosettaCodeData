 nth←{
    sfx←4 2⍴'stndrdth'
    tens←(10<100|⍵)∧20>100|⍵
    (⍕⍵),sfx[(4×tens)⌈(⍳3)⍳10|⍵;]
 }
