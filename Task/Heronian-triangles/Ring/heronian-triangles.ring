size = 20
number = 0
see " a  b  c   area   perimeter" + nl
for i = 1 to size
    for j = i + 1 to size
        for k = j + 1 to size
            perim = (i + j + k) / 2
            heronian = sqrt(perim*(perim - i)*(perim - j)*(perim-k))
            if heronian = floor(heronian)
               if gcd(gcd(i, j),k) = 1
                  if i + j > k and i + k > j and j + k > i
                     number += 1
                     if number <= 20
                        if len(string(i)) = 1 stri = " " + string(i) else stri = string(i) ok
                        if len(string(j)) = 1 strj = " " + string(j) else strj = string(j) ok
                        if len(string(k)) = 1 strk = " " + string(k) else strk = string(k) ok
                        if len(string(heronian)) = 1 her = " " + string(heronian) else her = string(heronian) ok
                        see stri + " "+ strj + " "+ strk + "   " + her + "     " + perim*2 + nl ok ok ok ok
        next
    next
next

func gcd gcd, b
     while b
           c   = gcd
           gcd = b
           b   = c % b
     end
     return gcd
