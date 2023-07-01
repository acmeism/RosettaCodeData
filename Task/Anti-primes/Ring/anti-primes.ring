# Project : Anti-primes

see "working..." + nl
see "wait for done..." + nl + nl
see "the first 20 anti-primes are:" + nl + nl
maxDivisor = 0
num = 0
n = 0
result = list(20)
while num < 20
      n = n + 1
      div = factors(n)
      if (div > maxDivisor)
         maxDivisor = div
         num = num + 1
         result[num] = n
      ok
end
see "["
for n = 1 to len(result)
    if n < len(result)
       see string(result[n]) + ","
    else
       see string(result[n]) + "]" + nl + nl
    ok
next
see "done..." + nl

func factors(an)
     ansum = 2
     if an < 2
        return(1)
     ok
     for nr = 2 to an/2
         if an%nr = 0
            ansum = ansum+1
         ok
     next
     return ansum
