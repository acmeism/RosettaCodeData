size = 100
sum = 0
prime = 0
for i = 1 to size
   for j = i + 1 to size
       for k = 1 to size
           if pow(i,2) + pow(j,2) = pow(k,2) and (i+j+k) < 101
              if gcd(i,j) = 1 prime += 1 ok
              sum += 1
              see "" + i + " " + j + " " + k + nl ok
       next
   next
next
see "Total : " + sum + nl
see "Primitives : " + prime + nl

func gcd gcd, b
     while b
           c   = gcd
           gcd = b
           b   = c % b
     end
     return gcd
