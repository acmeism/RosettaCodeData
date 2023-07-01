load "stdlib.ring"

see "working..." + nl

p = 1
num = 0
limit1 = 36
limit2 = 41
safe1 = 1000000
safe2 = 10000000

see "the first 35 Safeprimes are: " + nl
while true
      p = p + 1
      p2 = (p-1)/2
      if isprime(p) and isprime(p2)
         num = num + 1
         if num < limit1
            see " " + p
         else
            exit
         ok
      ok
end

see nl + "the first 40 Unsafeprimes are: " + nl
p = 1
num = 0
while true
      p = p + 1
      p2 = (p-1)/2
      if isprime(p) and not isprime(p2)
         num = num + 1
         if num < limit2
            see " " + p
         else
            exit
         ok
      ok
end

p = 1
num1 = 0
num2 = 0
while true
      p = p + 1
      p2 = (p-1)/2
      if isprime(p) and isprime(p2)
         if p < safe1
            num1 = num1 + 1
         ok
         if p < safe2
            num2 = num2 + 1
         else
            exit
         ok
      ok
end

see nl + "safe primes below 1,000,000: " + num1 + nl
see "safe primes below 10,000,000: " + num2 + nl

p = 1
num1 = 0
num2 = 0
while true
      p = p + 1
      p2 = (p-1)/2
      if isprime(p) and not isprime(p2)
         if p < safe1
            num1 = num1 + 1
         ok
         if p < safe2
            num2 = num2 + 1
         else
            exit
         ok
      ok
end

see "unsafe primes below 1,000,000: " + num1 + nl
see "unsafe primes below 10,000,000: " + num2 + nl

see "done..." + nl
