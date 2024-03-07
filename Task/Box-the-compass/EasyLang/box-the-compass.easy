func$ expand cp$ .
   for c$ in strchars cp$
      if c$ = "N"
         r$ &= "north"
      elif c$ = "E"
         r$ &= "east"
      elif c$ = "S"
         r$ &= "south"
      elif c$ = "W"
         r$ &= "west"
      elif c$ = "b"
         r$ &= "by"
      else
         r$ &= "-"
      .
   .
   h$ = strchar (strcode substr r$ 1 1 - 32)
   return h$ & substr r$ 2 999
.
proc main . .
   cp$[] = [ "N" "NbE" "N-NE" "NEbN" "NE" "NEbE" "E-NE" "EbN" "E" "EbS" "E-SE" "SEbE" "SE" "SEbS" "S-SE" "SbE" "S" "SbW" "S-SW" "SWbS" "SW" "SWbW" "W-SW" "WbS" "W" "WbN" "W-NW" "NWbW" "NW" "NWbN" "N-NW" "NbW" ]
   print "Index  Degrees  Compass point"
   print "-----  -------  -------------"
   for i = 0 to 32
      ind = (i + 1) mod1 32
      heading = i * 11.25
      if i mod 3 = 1
         heading += 5.62
      elif i mod 3 = 2
         heading -= 5.62
      .
      print ind & "\t" & heading & "\t" & expand cp$[ind]
   .
.
main
