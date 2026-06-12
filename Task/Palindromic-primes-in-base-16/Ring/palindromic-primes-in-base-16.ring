load "stdlib.ring"
see "working..." + nl
see "Palindromic primes in base 16:" + nl
row = 0
limit = 500

for n = 1 to limit
    hex = hex(n)
    if ispalindrome(hex) and isprime(n)
       see "" + upper(hex) + " "
       row = row + 1
       if row%5 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " palindromic primes in base 16" + nl
see "done..." + nl
