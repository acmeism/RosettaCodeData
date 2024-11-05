func[] base20 n .
   if n < 20
      return [ n ]
   .
   r[] = base20 (n div 20)
   r[] &= n mod 20
   return r[]
.
mayan$[] = [ "    " " ∙  " " ∙∙ " "∙∙∙ " "∙∙∙∙" ]
func$[] mayan d .
   r$[] = [ mayan$[1] mayan$[1] mayan$[1] mayan$[1] ]
   if d = 0
      r$[4] = " Θ  "
      return r$[]
   .
   for i = 4 downto 1
      if d >= 5
         r$[i] = "────"
         d -= 5
      else
         r$[i] = mayan$[d + 1]
         break 1
      .
   .
   return r$[]
.
proc drawma . mayans$[][] .
   idx = len mayans$[][]
   write "╔"
   for i to idx
      for j to 4
         write "═"
      .
      if i < idx
         write "╦"
      else
         print "╗"
      .
   .
   for i to 4
      write "║"
      for j to idx
         write mayans$[j][i] & "║"
      .
      print ""
   .
   write "╚"
   for i to idx
      for j to 4
         write "═"
      .
      if i < idx
         write "╩"
      else
         print "╝"
      .
   .
.
for n in [ 4005 8017 326205 886205 1081439556 ]
   print n
   digs[] = base20 n
   mayans$[][] = [ ]
   for d in digs[]
      mayans$[][] &= mayan d
   .
   drawma mayans$[][]
   print ""
.
