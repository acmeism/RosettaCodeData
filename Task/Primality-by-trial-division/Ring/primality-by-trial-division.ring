give n
flag = isPrime(n)
if flag = 1 see n + " is a prime number"
else see n + " is not a prime number" ok

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
