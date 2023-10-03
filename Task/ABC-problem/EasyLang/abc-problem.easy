b$[][] = [ [ "B" "O" ] [ "X" "K" ] [ "D" "Q" ] [ "C" "P" ] [ "N" "A" ] [ "G" "T" ] [ "R" "E" ] [ "T" "G" ] [ "Q" "D" ] [ "F" "S" ] [ "J" "W" ] [ "H" "U" ] [ "V" "I" ] [ "A" "N" ] [ "O" "B" ] [ "E" "R" ] [ "F" "S" ] [ "L" "Y" ] [ "P" "C" ] [ "Z" "M" ] ]
len b[] len b$[][]
global w$[] cnt .
#
proc backtr wi . .
   if wi > len w$[]
      cnt += 1
      return
   .
   for i = 1 to len b$[][]
      if b[i] = 0 and (b$[i][1] = w$[wi] or b$[i][2] = w$[wi])
         b[i] = 1
         backtr wi + 1
         b[i] = 0
      .
   .
.
for s$ in [ "A" "BARK" "BOOK" "TREAT" "COMMON" "SQUAD" "CONFUSE" ]
   w$[] = strchars s$
   cnt = 0
   backtr 1
   print s$ & " can be spelled in " & cnt & " ways"
.
