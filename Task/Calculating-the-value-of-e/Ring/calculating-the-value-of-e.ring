# Project : Calculating the value of e

decimals(14)

for n = 1 to 100000
     e = pow((1 + 1/n),n)
next
see "Calculating the value of e with method #1:" + nl
see "e = " + e + nl

e = 0
for n = 0 to 12
     e = e + (1 / factorial(n))
next
see "Calculating the value of e with method #2:" + nl
see "e = " + e + nl

func factorial(n)
       if n = 0 or n = 1
          return 1
       else
          return n * factorial(n-1)
       ok
