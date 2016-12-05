see "first twenty primes : "
i = 1
nr = 0
while i <= 20
      nr += 1
      if isPrime(nr) see " " + nr i += 1 ok
end

see "primes between 100 and 150 : "
for nr = 100 to 150
    if isPrime(nr) see " " + nr ok
next
see nl

see "primes between 7,700 and 8,000 : "
i = 0
for nr = 7700 to 8000
    if isPrime(nr) i += 1 ok
next
see i + nl

see "The 10,000th prime : "
i = 1
nr = 0
while i <= 10000
      nr += 1
      if isPrime(nr) i += 1 ok
end
see nr + nl

func isPrime n
     if n <= 1 return false ok
     if n <= 3 return true ok
     if (n & 1) = 0 return false ok
     for t = 3 to sqrt(n) step 2
         if (n % t) = 0 return false ok
     next
     return true
