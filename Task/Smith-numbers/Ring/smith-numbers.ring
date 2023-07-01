# Project : Smith numbers

see "All the Smith Numbers < 1000 are:" + nl

for prime = 1 to 1000
    decmp = []
    sum1 = sumDigits(prime)
    decomp(prime)
    sum2 = 0
    if len(decmp)>1
       for n=1 to len(decmp)
           cstr = string(decmp[n])
           for m= 1 to len(cstr)
               sum2 = sum2 + number(cstr[m])
           next
       next
    ok
    if sum1 = sum2
       see "" + prime + " "
    ok
next

func decomp nr
     for i = 1 to nr
         if isPrime(i) and nr % i = 0
            add(decmp, i)
            pr = i
            while true
                  pr = pr * i
                  if nr%pr = 0
                     add(decmp, i)
                  else
                     exit
                  ok
            end
         ok
     next

func isPrime num
     if (num <= 1) return 0 ok
        if (num % 2 = 0 and num != 2) return 0 ok
        for i = 3 to floor(num / 2) -1 step 2
            if (num % i = 0) return 0 ok
        next
        return 1

func sumDigits n
     sum = 0
     while n > 0.5
           m = floor(n / 10)
           digit = n - m * 10
           sum = sum + digit
           n = m
     end
     return sum
