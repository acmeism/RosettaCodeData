seq←hailstone n;next
⍝ Returns the hailstone sequence for a given number

seq←n                   ⍝ Init the sequence
:While n≠1
    next←(n÷2) (1+3×n)  ⍝ Compute both possibilities
    n←next[1+2|n]       ⍝ Pick the appropriate next step
    seq,←n              ⍝ Append that to the sequence
:EndWhile
