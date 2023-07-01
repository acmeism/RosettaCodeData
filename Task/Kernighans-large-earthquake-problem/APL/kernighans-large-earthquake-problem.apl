quakes←{
    ⍺←6
    nl←⎕UCS 13 10
    file←80 ¯1⎕MAP ⍵
    lines←((~file∊nl)⊆file)~¨⊂nl
    keep←⍺{0::0 ⋄ ⍺ < ⍎3⊃(~⍵∊4↑⎕TC)⊆⍵}¨lines
    ↑keep/lines
}
