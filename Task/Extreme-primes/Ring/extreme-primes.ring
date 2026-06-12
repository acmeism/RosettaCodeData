see "working..." + nl
limit = 2000
Primes = []

for n = 1 to limit
     if isPrime(n)
        add(Primes,n)
     ok
next
sum = 0
row = 0

for n = 1 to len(Primes)
     sum = sum + Primes[n]
     if isPrime(sum)
        row++
        see "" + sum + " "
        if row % 10 = 0
           see nl
        ok
      ok
next
see "done..." + nl

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
