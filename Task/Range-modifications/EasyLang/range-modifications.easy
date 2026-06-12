global range[][] .
proc start r$ .
   print "start with \"" & r$ & "\""
   range[][] = [ ]
   for s$ in strsplit r$ ","
      range[][] &= number strsplit s$ "-"
   .
.
func$ str &range[][] .
   for r[] in range[][]
      if s$ <> "" : s$ &= ","
      s$ &= r[1] & "-" & r[2]
   .
   return s$
.
proc add0 v .
   for r[] in range[][]
      if v >= r[1] and v <= r[2] : return
      if v < r[1]
         b = v
         if v = r[1] - 1 : b = r[2]
         if len nr[][] >= 1 and nr[$][2] + 1 = v
            nr[$][2] = b
         else
            nr[][] &= [ v b ]
         .
         if v <> r[1] - 1 : nr[][] &= r[]
         done = 1
      else
         nr[][] &= r[]
      .
   .
   if done = 0
      if len nr[][] >= 1 and nr[$][2] + 1 = v
         nr[$][2] = v
      else
         nr[][] &= [ v v ]
      .
   .
   swap range[][] nr[][]
.
proc add v .
   add0 v
   print "add " & v & " -> " & str range[][]
.
proc remove0 v .
   for r[] in range[][]
      if v >= r[1] and v <= r[2]
         a = r[1]
         b = r[2]
         if v = a or v = b
            if v = a : a += 1
            if v = b : b -= 1
            if b >= a : nr[][] &= [ a b ]
         else
            nr[][] &= [ a v - 1 ]
            nr[][] &= [ v + 1 b ]
         .
      else
         nr[][] &= r[]
      .
   .
   swap range[][] nr[][]
.
proc remove v .
   remove0 v
   print "remove " & v & " -> " & str range[][]
.
start ""
add 77
add 79
add 78
remove 77
remove 78
remove 79
print ""
start "1-3,5-5"
add 1
remove 4
add 7
add 8
add 6
remove 7
print ""
start "1-5,10-25,27-30"
add 26
add 9
add 7
remove 26
remove 9
remove 7
