# Project : Sailors, coconuts and a monkey problem

scm(5)
scm(6)

func scm(sailors)
        sm1 = sailors-1
        if sm1 = 0
           m = sailors
        else
           for n=sailors to 1000000000 step sailors
                m = n
                for j=1 to sailors
                     if m % sm1 != 0
                        m = 0
                        exit
                     ok
                     m = sailors*m/sm1+1
                next
                if m != 0
                   exit
                ok
           next
        ok
        see "Solution with " + sailors + " sailors: " + m + nl
        for i=1 to sailors
             m = m - 1
             m = m / sailors
             see "Sailor " + i + " takes " + m + " giving 1 to the monkey and leaving " + m*sm1 + nl
             m = m * sm1
        next
        see "In the morning each sailor gets " + m/sailors + " nuts" + nl + nl
