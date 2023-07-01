fpg←{⎕IO←0
    ⍺←4 4
    (s∨.<0)∨2≠⍴s←⍺:'invalid shape:'s
    0≠⍴⍴⍵:'invalid shuffle count:'⍵
    d←d,-d←↓2 2⍴3↑1
    e←¯1+⍴c←'↑↓←→○'
    b←w←s⍴w←1⌽⍳×/s
    z←⊃{
        z p←⍵
        n←(?⍴p)⊃p←(p≡¨(⊂s)|p)/p←(d~p)+⊂z
        b[z n]←b[n z]
        -⍨\n z
    }⍣⍵⊢(s-1)0
    ⎕←b
    ⍬{
        b≡w:'win'
        0=⍴⍺:⍞∇ ⍵
        e=i←c⍳m←⊃⍺:'quit'
        i>e:⍞∇ ⍵⊣⎕←'invalid direction:'m
        n≢s|n←⍵+i⊃d:⍞∇ ⍵⊣'out of bounds:'m
        b[⍵ n]←b[n ⍵]
        ⎕←(s×0≠⍴⍺)⍴b
        (1↓⍺)∇ n
    }z
}
