prime = 18705
decomp(prime)

func decomp nr
x = ""
for i = 1 to nr
    if isPrime(i) and nr % i = 0
       x = x + string(i) + " * " ok
    if i = nr
       x2 = substr(x,1,(len(x)-2))
       see string(nr) + " = " + x2 + nl ok
next

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
