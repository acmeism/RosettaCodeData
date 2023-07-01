for ap = 1 to 5
    see "k = " + ap + ":"
    aList = []
    for n = 1 to 200
        num = 0
        for nr = 1 to n
            if n%nr=0 and isPrime(nr)=1
               num = num + 1
               pr = nr
               while true
                     pr = pr * nr
                     if n%pr = 0
                        num = num + 1
                     else exit ok
               end ok
        next
        if (ap = 1 and isPrime(n) = 1) or (ap > 1 and num = ap)
           add(aList, n)
           if len(aList)=10 exit ok ok
     next
     for m = 1 to len(aList)
           see " " + aList[m]
     next
     see nl
next

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
