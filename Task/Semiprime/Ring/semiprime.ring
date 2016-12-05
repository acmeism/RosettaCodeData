prime = 1679
decomp(prime)

func decomp nr
x = ""
sum = 0
for i = 1 to nr
    if isPrime(i) and nr % i = 0
       sum = sum + 1
       x = x + string(i) + " * " ok
    if i = nr and sum = 2
       x2 = substr(x,1,(len(x)-2))
       see string(nr) + " = " + x2 + "is semiprime" + nl
    but i = nr and sum != 2 see string(nr) + " is not semiprime" + nl ok
next

func isPrime n
     if n < 2 return false ok
     if n < 4 return true ok
     if n % 2 = 0 return false ok
     for d = 3 to sqrt(n) step 2
         if n % d = 0 return false ok
     next	
     return true
