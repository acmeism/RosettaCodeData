a = leftFact(0,10,1)
see "" + a + nl

func leftFact f,t,s
     see "------ From " + f + " --To -> " + t +" Step " + s + " -------" + nl
     for i = f to t step s
         leftFact = 1
         fct = 1
         for j = 1 to i - 1
             fct = fct * j
             leftFact = leftFact + fct
         next
         if i >= 1000 see "" + i + " " + len(string(leftFact)) + " digits" + nl
         else see "" + i + " " + leftFact + nl ok
     next
