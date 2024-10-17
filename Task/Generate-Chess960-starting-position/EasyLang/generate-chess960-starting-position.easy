len t$[] 8
proc randins c$ l r . pos .
   repeat
      pos = random (r - l + 1) + l - 1
      until t$[pos] = ""
   .
   t$[pos] = c$
.
randins "K" 2 7 king
randins "R" 1 (king - 1) h
randins "R" (king + 1) 8 h
randins "B" 1 8 b1
repeat
   randins "B" 1 8 b2
   until (b2 - b1) mod 2 <> 0
   t$[b2] = ""
.
randins "Q" 1 8 b1
randins "N" 1 8 b1
randins "N" 1 8 b1
print strjoin t$[]
