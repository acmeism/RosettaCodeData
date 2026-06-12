load "stdlib.ring"

see "working..." + nl
see "Numbers in which all substrings are primes:" + nl

row = 0
limit1 = 500

for n = 1 to limit1
    flag = 1
    strn = string(n)
    for m = 1 to len(strn)
        for p = 1 to len(strn)
            temp = substr(strn,m,p)
            if temp != ""
                if isprime(number(temp))
                   flag = 1
                else
                   flag = 0
                   exit 2
                ok
            ok
         next
      next
      if flag = 1
         see "" + n + " "
      ok
next

see nl + "Found " + row + " numbers in which all substrings are primes" + nl
see "done..." + nl
