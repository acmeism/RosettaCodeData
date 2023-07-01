see "h(1) = 1" + nl
for nr = 1 to 19
     see "h(" + (nr+1) + ") = " + hamming(nr) + nl
next
see "h(1691) = " + hamming(1690) + nl
see nl

func hamming limit
     h = list(1690)
     h[1] =1
     x2 = 2 x3 = 3 x5 =5
     i  = 0 j  = 0 k  =0
     for n =1 to limit
         h[n]  = min(x2, min(x3, x5))
         if x2 = h[n]  i = i +1  x2 =2 *h[i] ok
         if x3 = h[n]  j = j +1  x3 =3 *h[j] ok
         if x5 = h[n]  k = k +1  x5 =5 *h[k] ok
     next
     hamming = h[limit]
     return hamming
