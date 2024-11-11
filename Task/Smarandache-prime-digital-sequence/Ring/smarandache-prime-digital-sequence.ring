load "stdlib.ring"

sum = 0
num = 0
Sma = []
while true
      num += 1
      flag = 0
      numb = 0
      if isPrime(num)
         nrStr = string(num)
         for n = 1 to len(nrStr)
             nrTemp = number(nrStr[n])
             if isPrime(nrTemp)
                numb += 1
                if numb = len(nrStr)
                   add(Sma,num)
                   sum += 1
                   if sum = 100
                      exit 2
                   ok
                ok
             else
                exit
             ok
          next
       ok
end

for n = 1 to 25
    if len(string(Sma[n])) = 1
       see "    " + Sma[n]
    ok
    if len(string(Sma[n])) = 2
       see "   " + Sma[n]
    ok
    if len(string(Sma[n])) = 3
       see "  " + Sma[n]
    ok
    if len(string(Sma[n])) = 4
       see " " + Sma[n]
    ok
    if n%5 = 0
       see nl
    ok
next

see nl
see "Hundredth SPDS prime: " + Sma[100]
