dict$[] = [ "a" "bc" "abc" "cd" "b" ]
proc wbreak s$ &w$[] .
   if s$ = ""
      print "  " & w$[]
      return
   .
   for w$ in dict$[]
      l = len w$
      if substr s$ 1 l = w$
         w$[] &= w$
         wbreak substr s$ (l + 1) 9999 w$[]
         len w$[] -1
      .
   .
.
for s$ in [ "abcd" "abbc" "abcbcd" "acdbc" "abcdd" ]
   print s$ & " ->"
   wbreak s$ w$[]
   print ""
.
