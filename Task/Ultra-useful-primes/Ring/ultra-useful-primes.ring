see "works..." + nl
limit = 10

for n = 1 to limit
    k = -1
    while true
          k = k + 2
          num = pow(2,pow(2,n)) - k
          if isPrime(num)
             ? "n = " + n + " k = " + k
             exit
          ok
    end
next
see "done.." + nl

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
