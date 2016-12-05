legendreP n x = go n 1 x
  where go 0 p2 _  = p2
        go 1 _  p1 = p1
        go n p2 p1 = go (n-1) p1 $ ((2*n-1)*x*p1 - (n-1)*p2)/n

legendreP' n x = n/(x^2-1)*(x*legendreP n x - legendreP (n-1) x)
