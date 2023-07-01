 i←{x←⍵
    q←(×∘4)⍣{⍺>x}⊢1
    ⊃{  r z q←⍵
        q←⌊q÷4
        t←(z-r)-q
        r←⌊r÷2
        z←z t[1+t≥0]
        r←r+q×t≥0
        r z q
    }⍣{ r z q←⍺
        q≤1
    }⊢0 x q
 }
