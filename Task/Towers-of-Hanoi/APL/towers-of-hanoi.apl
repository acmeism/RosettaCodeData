hanoi←{
    move←{
        n from to via←⍵
        n≤0:⍬
        l←∇(n-1) from via to
        r←∇(n-1) via to from
        l,(⊂from to),r
    }
    '⊂Move disk from pole ⊃,I1,⊂ to pole ⊃,I1'⎕FMT↑move ⍵
}
