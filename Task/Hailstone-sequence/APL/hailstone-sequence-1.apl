⍝ recursive dfn:
dfnHailstone←{
    c←⊃⌽⍵ ⍝ last element
    1=c:1 ⍝ if it is 1, stop.
    ⍵,∇(1+2|c)⊃(c÷2)(1+3×c) ⍝ otherwise pick the next step, and append the result of the recursive call
}

⍝ tradfn version:
∇seq←hailstone n;next
⍝ Returns the hailstone sequence for a given number

seq←n                   ⍝ Init the sequence
:While n≠1
    next←(n÷2) (1+3×n)  ⍝ Compute both possibilities
    n←next[1+2|n]       ⍝ Pick the appropriate next step
    seq,←n              ⍝ Append that to the sequence
:EndWhile
∇
