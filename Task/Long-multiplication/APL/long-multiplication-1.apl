longmul←{⎕IO←0
    sz←⌈/≢¨x y←↓⌽↑⌽¨⍺⍵
    ds←+⌿↑(⌽⍳sz)⌽¨↓(¯2×sz)↑[1]x∘.×y
    mlt←{(1⌽⌊⍵÷10)+10|⍵}⍣≡⊢ds
    0=≢mlt←(∨\0≠mlt)/mlt:,0
    mlt
}
