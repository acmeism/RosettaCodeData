see "works..." + nl
numCalmo = 0
limit = 1000
for n = 1 to limit
    Calmo = []
    for m = 2 to n/2
        if n % m = 0
           add(Calmo,m)
        ok
    next
    flag = 1
    lenCalmo = len(Calmo)
    if (lenCalmo > 5) and (lenCalmo % 3 = 0)
        for p = 1 to lenCalmo - 2 step 3
            sum = Calmo[p] + Calmo[p+1] + Calmo[p+2]
            if not isPrime(sum)
               flag = 0
               exit
            ok
        next
        if flag = 1
           numCalmo++
           see "n(" + numCalmo + ") = " + n + nl
           see "divisors = ["
           for p = 1 to lenCalmo - 2 step 3
               sumCalmo = Calmo[p] + Calmo[p+1] + Calmo[p+2]
               if not isPrime(sumCalmo)
                  exit
               else
                  if p = 1
                     see "" + Calmo[p] + " " + Calmo[p+1] + " " + Calmo[p+2]
                  else
                     see " " + Calmo[p] + " " + Calmo[p+1] + " " + Calmo[p+2]
                  ok
               ok
            next
            see "]" + nl
            for p = 1 to lenCalmo - 2 step 3
                sumCalmo = Calmo[p] + Calmo[p+1] + Calmo[p+2]
                if isPrime(sumCalmo)
                   see "" + Calmo[p] + " + " + Calmo[p+1] + " + " + Calmo[p+2] + " = " + sumCalmo + " is prime" + nl
                ok
            next
            see nl
        ok
     ok
next
see "Found " + numCalmo + " Calmo numbers" + nl
see "done..." + nl

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
