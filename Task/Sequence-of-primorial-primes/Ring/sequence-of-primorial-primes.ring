# Project : Sequence of primorial primes

max = 9999
primes = []
for n = 1 to max
     if isprime(n) = 1
        add(primes, n)
     ok
next
for n = 1 to len(primes)
     sum = 1
     for m = 1 to n
          sum = sum * primes[m]
     next
     if (isprime(sum+1) or isprime(sum-1)) = 1
        see "" + n + " "
     ok
next

func isprime(num)
       if (num <= 1) return 0 ok
       if (num % 2 = 0) and num != 2 return 0 ok
       for i = 3 to floor(num / 2) -1 step 2
            if (num % i = 0) return 0 ok
       next
       return 1
