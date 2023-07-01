# Project : ANti-primes

see "working..." + nl
see "wait for done..." + nl + nl
see "the first 15 Anti-primes Plus are:" + nl + nl
num = 1
n = 0
result = list(15)
while num < 16
      n = n + 1
      div = factors(n)
      if div = num
         result[num] = n
         num = num + 1
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
