# Project : Higher-order functions

docalcs(1,10,"squares",:square)
docalcs(1,10,"cubes",:cube)

func square(n)
        return n * n

func cube(n)
        return n * n * n

func docalcs(from2,upto,title,func2)
       see title + " -> " + nl
       for i = from2 to upto
            x = call func2(i)
            see x + nl
       next
       see nl
