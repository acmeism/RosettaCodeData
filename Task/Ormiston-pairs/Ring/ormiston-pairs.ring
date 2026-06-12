see "working..." + nl
see "First 30 Ormiston pairs:" + nl
limit = 1000000
Primes = []
Primes1 = []
Primes2 = []

add(Primes,2)
pr = 1
while true
    pr = pr + 2
    if isPrime(pr) and pr < limit
       add(Primes,pr)
    ok
    if pr > limit
       exit
    ok
end

n = 0
row = 0

for n = 1 to len(Primes) - 1
    Primes1 = []
    Primes2 = []
    str1 = string(Primes[n])
    str2 = string(Primes[n+1])
    for p = 1 to len(str1)
        add(Primes1,substr(str1,p,1))
    next
    for p = 1 to len(str2)
        add(Primes2,substr(str2,p,1))
    next
    Sort1 = sort(Primes1)
    Sort2 = sort(Primes2)

    flag = 1
    if len(Sort1) = len(Sort2)
       for p = 1 to len(Sort1)
           if Sort1[p] != Sort2[p]
              flag = 0
              exit
           ok
       next
       if flag = 1
          row++
          if row < 31
             str1m = str1
             str2m = str2
             see "(" + str1 + ", " + str2 + ")  "
             if row % 3 = 0
                see nl
             ok
          ok
       ok
    ok
end
see nl + "Number of pairs < 1,000,000: " + row + nl
see "done..." + nl

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
