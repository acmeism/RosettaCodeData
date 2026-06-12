# Project : Mersenne primes

n = 0
while true
        n = n +1
        if isprime(pow(2,n)-1) = 1
           see n + nl
        ok
end

func isprime num
       if (num <= 1) return 0 ok
       if (num % 2 = 0) and num != 2 return 0 ok
       for i = 3 to floor(num / 2) -1 step 2
            if (num % i = 0) return 0 ok
       next
       return 1
