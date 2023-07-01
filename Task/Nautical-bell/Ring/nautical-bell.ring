# Project : Nautical bell

m = 0
for n = 0 to 23
     if n = 23
        see "23" + ":30" + " = " + "7 bells" + nl
     else
        m = m + 1
        see "" + n%23 + ":30" + " = " + m + " bells" + nl
     ok
     if n = 23
        see "00" + ":00" + " = " + "8 bells" + nl
     else
        m = m + 1
        see "" + (n%23+1) + ":00" + " = " + m + " bells" + nl
        if m = 8
           m = 0
        ok
     ok
next
