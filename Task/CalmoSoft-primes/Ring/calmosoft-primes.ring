see "works..." + nl
limit = 100
Primes = []
OldPrimes = []
NewPrimes = []
for p = 1 to limit
    if isPrime(p)
       add(Primes,p)
    ok
next

lenPrimes = len(Primes)

for n = 1 to lenPrimes
    num = 0
    OldPrimes = []
    for m = n to lenPrimes
        num = num + Primes[m]
        add(OldPrimes,Primes[m])
        if isPrime(num)
           if len(OldPrimes) > len(NewPrimes)
              NewPrimes = OldPrimes
           ok
        ok
    next
next

str = "["
for n = 1 to len(NewPrimes)
    if n = len(NewPrimes)
       str = str + newPrimes[n] + "]"
       exit
    ok
    str = str + newPrimes[n] + ", "
next

sum = 0
strsum = ""
for n = 1 to len(NewPrimes)
    sum = sum + newPrimes[n]
    if n = len(NewPrimes)
       strsum = strsum + newPrimes[n] + " = " + sum + " is prime number"
       exit
    ok
    strsum = strsum + newPrimes[n] + " + "
next

see str + nl
see strsum + nl
see "The longest sequence of CalmoSoft primes = " + len(NewPrimes) + nl
see "done.." + nl

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
