lunar←{
    dgt←{10⊥⍺ ⍺⍺⍥((⊢↑⍨1⌈≢)∘(10∘⊥⍣¯1))⍵}
    add←{⌽⌈⌿↑⌽¨⍺⍵}dgt
    mul←{⌈/(-0,⍳l)⊖((⍴⍺)+l←(⍴⍵)-1)↑⍺∘.⌊⍵}dgt

    fn←⍺⍺{aa←⍺⍺ ⋄ ⎕CR'aa'}⍬
    fn='+':⍺ add¨ ⍵
    fn='×':⍺ mul¨ ⍵
    'Not supported'⎕SIGNAL 16
}

lunartest←{
    nums←(976 348) (23 321) (232 35) (123 32192 415 8)

    test←{aa←⍺⍺ ⋄ ⎕←(1↓∊(⎕CR'aa'),¨⍕¨⍵),'=',⍕⍺⍺ lunar/⍵}

    ⎕←'Lunar addition:' ⋄ _← +test¨nums
    ⎕←''
    ⎕←'Lunar multiplication:' ⋄ _← ×test¨nums

    ⎕←''
    ⎕←'First 20 distinct even lunar numbers:'
    ⎕←20↑∪ 2 ×lunar 0,⍳201

    ⎕←''
    ⎕←'First 20 lunar squares:'
    ⎕←×lunar⍨ 0,⍳19

    ⎕←''
    ⎕←'First 18 lunar factorials:'
    ⎕←{×lunar/⍳⍵}¨⍳18

    fsmsqr←⊃1↓⍸(⊢<¯1∘⌽)×lunar⍨ ⍳2000
    ⎕←''
    ⎕←'First lunar square smaller than the previous: '
    ⎕←(⍕fsmsqr),'^2 = ',⍕×lunar⍨fsmsqr
    ⎕←(⍕fsmsqr-1),'^2 = ',⍕×lunar⍨fsmsqr-1
}
