div←{
    {
        q r d←⍵
        (≢d) > n←≢r : q r
        c ← (⊃⌽r) ÷ ⊃⌽d
        ∇ (c,q) ((¯1↓r) - c × ¯1↓(-n)↑d) d
    } ⍬ ⍺ ⍵
}
