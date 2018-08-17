# Project : Pernicious numbers

see "The first 25 pernicious numbers:" + nl
nr = 0
for n=1 to 50
    sum = 0
    str = decimaltobase(n, 2)
    for m=1 to len(str)
        if str[m] = "1"
           sum = sum + 1
        ok
    next
    if isprime(sum)
       nr = nr + 1
       see "" + n + " "
    ok
    if nr = 25
       exit
    ok
next

func decimaltobase(nr, base)
     binary = 0
     i = 1
     while(nr != 0)
           remainder = nr % base
           nr = floor(nr/base)
           binary= binary + (remainder*i)
           i = i*10
     end
     return string(binary)

func isprime num
     if (num <= 1) return 0 ok
     if (num % 2 = 0 and num != 2) return 0 ok
     for i = 3 to floor(num / 2) -1 step 2
         if (num % i = 0) return 0 ok
     next
     return 1
