for i = 1 to 10000
    if perfect(i) see i + nl ok
next

func perfect n
     sum = 0
     for i = 1 to n - 1
         if n % i = 0 sum = sum + i ok
     next
if sum = n return 1 else return 0 ok
return sum
