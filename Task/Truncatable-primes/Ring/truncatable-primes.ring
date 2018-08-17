# Project : Truncatable primes

for n = 1000000 to 1 step -1
    flag = 1
    flag2 = 1
    strn = string(n)
    for nr = 1 to len(strn)
        if strn[nr] = "0"
           flag2 = 0
        ok
    next
    if flag2 = 1
       for m = 1 to len(strn)
           strp = right(strn, m)
           if isprime(number(strp))
           else
              flag = 0
              exit
           ok
       next
       if flag = 1
          nend = n
          exit
       ok
    ok
next
see "Largest left truncatable prime : " + nend + nl

for n = 1000000 to 1 step -1
    flag = 1
    strn = string(n)
    for m = 1 to len(strn)
        strp = left(strn, len(strn) - m + 1)
        if isprime(number(strp))
        else
           flag = 0
           exit
        ok
    next
    if flag = 1
       nend = n
       exit
    ok
next
see "Largest right truncatable prime : " + nend + nl

func isprime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
