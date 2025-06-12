proc test s$[] .
   ident = 1
   ascend = 1
   for i = 2 to len s$[]
      h = strcmp s$[i] s$[i - 1]
      if h <> 0 : ident = 0
      if h <= 0 : ascend = 0
   .
   print s$[]
   if ident = 1 : print "all equal"
   if ascend = 1 : print "ascending"
   print ""
.
test [ "AA" "BB" "CC" ]
test [ "AA" "AA" "AA" ]
test [ "AA" "CC" "BB" ]
test [ "AA" "ACB" "BB" "CC" ]
test [ "single_element" ]
