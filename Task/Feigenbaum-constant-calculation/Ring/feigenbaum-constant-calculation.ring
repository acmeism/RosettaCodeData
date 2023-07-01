# Project : Feigenbaum constant calculation

decimals(8)
see "Feigenbaum constant calculation:" + nl
maxIt = 13
maxItJ = 10
a1 = 1.0
a2 = 0.0
d1 = 3.2
see "i     " + "d" + nl
for i = 2 to maxIt
     a = a1 + (a1 - a2) / d1
     for j = 1 to maxItJ
          x = 0
          y = 0
          for k = 1 to pow(2,i)
               y = 1 - 2 * y * x
               x = a - x * x
          next
          a = a - x / y
     next
     d = (a1 - a2) / (a - a1)
     if i < 10
        see "" + i + "    " + d + nl
     else
        see "" + i + "  " + d + nl
     ok
     d1 = d
     a2 = a1
     a1 = a
next
