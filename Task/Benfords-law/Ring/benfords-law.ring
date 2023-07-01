# Project : Benford's law

decimals(3)
n= 1000
actual = list(n)
for x = 1 to len(actual)
     actual[x] = 0
next

for nr = 1 to n
     n1 = string(fibonacci(nr))
     j = number(left(n1,1))
     actual[j] = actual[j] + 1
next

see "Digit   " + "Actual   " + "Expected" + nl
for m = 1 to 9
     fr = frequency(m)*100
     see "" + m + "   " + (actual[m]/10) + "   " + fr + nl
next

func frequency(n)
      freq = log10(n+1) - log10(n)
      return freq

func log10(n)
      log1 = log(n) / log(10)
      return log1

func fibonacci(y)
       if y = 0 return 0 ok
       if y = 1 return 1 ok
       if y > 1 return fibonacci(y-1) + fibonacci(y-2) ok
