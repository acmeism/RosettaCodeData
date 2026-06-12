invseq←{
    t←1000×⍳10
    seq←0{
        (⍺+1)∇⍣(n>0)⊢⍵,n←+/⍺=⍵
    }⍣{
        ⍵∨.>⊃⌽t
    }⊢⍬
    ⎕←'First 100 elements:'
    ⎕←10 10⍴seq
    loc←{⊃⍸seq>⍵}¨t
    ⎕←'⊂First > ⊃,I5,⊂: ⊃,I5,⊂ at ⊃,I6'⎕FMT t,seq[loc],[1.5]loc
}
