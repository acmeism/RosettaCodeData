c = 0
see "Digital root of 627615 is " + digitRoot(627615, 10) + " persistance is " + c + nl
see "Digital root of 39390  is " + digitRoot(39390, 10) +  " persistance is " + c + nl
see "Digital root of 588225 is " + digitRoot(588225, 10) +  " persistance is " + c + nl
see "Digital root of 9992   is " + digitRoot(9992, 10) +  " persistance is " + c + nl

func digitRoot n,b
     c = 0
     while n >= b
           c = c + 1
           n = digSum(n, b)
     end
     return n

func digSum n, b
     s = 0
     while n != 0
           q = floor(n / b)
           s = s + n - q * b
           n = q
     end
     return s
