numer = 0
binomial(5,3)
see "(5,3) binomial = " + numer + nl

func binomial n, k
     if k > n return nil ok
     if k > n/2 k = n - k ok
     numer = 1
     for i = 1 to k
         numer = numer * ( n - i + 1 ) / i
     next
     return numer
