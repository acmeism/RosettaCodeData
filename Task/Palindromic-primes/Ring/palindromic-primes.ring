load "stdlib.ring"

see "working..." + nl
see "Palindromic primes are:" + nl
row = 0
limit1 = 1000
limit2 = 100000

palindromicPrimes(limit1)

see "Found " + row + " palindromic primes" + nl + nl
see "palindromic primes that are  <  100,000" + nl

palindromicPrimes(limit2)

see nl + "Found " + row + " palindromic primes that are < 100,000" + nl
see "done..." + nl

func palindromicPrimes(limit)
     row = 0
     for n = 1 to limit
         strn = string(n)
         if ispalindrome(strn) and isprime(n)
            row = row + 1
            see "" + n + " "
            if row%5 = 0
               see nl
            ok
         ok
     next
