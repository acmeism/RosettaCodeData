load "stdlib.ring"

see "working..." + nl

p = 0
num = 0
pr1 = 37
pr2 = 38
limit1 = 457
limit2 = 1000000
limit3 = 10000000
primes = []

see "first 36 strong primes:" + nl
while true
      p = p + 1
      if isprime(p)
         if p < limit1
            add(primes,p)
         else
            exit
         ok
      ok
end

ln = len(primes)
for n = 2 to ln-1
    tmp = (primes[n-1] + primes[n+1])/2
    if primes[n] > tmp
       num = num + 1
       if num < pr1
          see " " + primes[n]
       ok
    ok
next

see nl + "first 37 weak primes:" + nl

num = 0
ln = len(primes)
for n = 2 to ln-1
    tmp = (primes[n-1] + primes[n+1])/2
    if primes[n] < tmp
       num = num + 1
       if num < pr2
          see " " + primes[n]
       ok
    ok
next

p = 0
primes = []
while true
      p = p + 1
      if isprime(p)
         if p < limit3
            add(primes,p)
         else
            exit
         ok
      ok
end

primes2 = 0
primes3 = 0
ln = len(primes)
for n = 2 to ln-1
    tmp = (primes[n-1] + primes[n+1])/2
    if primes[n] > tmp
       if primes[n] < limit2
          primes2 = primes2 + 1
       ok
       if primes[n] < limit3
          primes3 = primes3 + 1
       else
          exit
       ok
    ok
next

see nl
see "strong primes below 1,000,000: " + primes2 + nl
see "strong primes below 10,000,000: " + primes3 + nl

primes2 = 0
primes3 = 0
ln = len(primes)
for n = 2 to ln-1
    tmp = (primes[n-1] + primes[n+1])/2
    if primes[n] < tmp
       if primes[n] < limit2
          primes2 = primes2 + 1
       ok
       if primes[n] < limit3
          primes3 = primes3 + 1
       else
          exit
       ok
    ok
next

see nl
see "weak primes below 1,000,000: " + primes2 + nl
see "weak primes below 10,000,000: " + primes3 + nl
