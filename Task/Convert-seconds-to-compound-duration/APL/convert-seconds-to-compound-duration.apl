duration←{
    names←'wk' 'd' 'hr' 'min' 'sec'
    parts←0 7 24 60 60⊤⍵
    fmt←⍕¨(parts≠0)/parts,¨names
    ¯2↓∊fmt,¨⊂', '
}
