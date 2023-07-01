for i = 1 to 100
    if isPrime(i) see "" + i + " " ok
next
see nl

func isPrime n
     if n < 2 return false ok
     if n < 4 return true ok
     if n % 2 = 0 return false ok
     for d = 3 to sqrt(n) step 2
         if n % d = 0 return false ok
     next	
     return true
