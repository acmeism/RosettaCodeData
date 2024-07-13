wordladder←{
    from to←⍵
    dict←((≢¨⍺)=≢to)/⍺

    dict{
        match←(⊂to)≡¨⊃∘⌽¨⍵
        ∨/match:⊃match/⍵
        0∊≢¨⍺⍵:⍬
        word←⊃⌽ladder←⊃⍵
        next←(1=⍺+.≠¨⊂word)/⍺
        (⍺~next)∇(1↓⍵),(⊂ladder),¨⊂¨next
    }⊂⊂from
}
task←{
    dict←(~dict∊⎕TC)⊆dict←⊃⎕NGET'unixdict.txt'
    pairs←('boy' 'man')('girl' 'lady')('john' 'jane')('child' 'adult')
    ⎕←↑↑{
        hdr←⍺,' → ',⍵,': '
        ladder←dict wordladder ⍺ ⍵
        0=≢ladder:hdr,'impossible'
        hdr,1↓∊'→',¨ladder
    }/¨pairs
}
