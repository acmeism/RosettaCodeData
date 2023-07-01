// Author: Gal Zsolt - 2023.02.26.
see "works..." + nl
divisors = []
divSum = 0
limit = 20000
counta = 0
countb = 0
countCompa = 0
countCompb = 0
for n = 1 to limit
    num = 0
    divSum = 0
    for m = 1 to n
        if n%m = 0
           num++
           divSum = divSum + m
        ok
    next
    for x = 1 to n
        if divSum/num = x
           add(divisors,n)
           counta++
           countb++
           if counta < 1001
              if not isPrime(n) and n!=1
                 countCompa++
              ok
           ok
           if counta = 1000
              countNuma = n
           ok
           if countb < 10001
              if not isPrime(n) and n!=1
                 countCompb++
              ok
           ok
           if countb = 10000
              countNumb = n
              exit 2
           ok
        ok
    next
next

see "The first 100 arithmetic numbers are:" + nl + nl

row = 0
for n = 1 to 100
    row++
    see "" + divisors[n] + " "
    if row%10=0
       see nl
    ok
next

see nl
see "1000th arithmetic number is " + countNuma + nl
see "Number of composite arithmetic numbers <= " + countNuma + ":" + countCompa + nl+nl

see "10000th arithmetic number is " + countNumb + nl
see "Number of composite arithmetic numbers <= " + countNumb + ":" + countCompb + nl
see "done..." + nl

func isPrime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
