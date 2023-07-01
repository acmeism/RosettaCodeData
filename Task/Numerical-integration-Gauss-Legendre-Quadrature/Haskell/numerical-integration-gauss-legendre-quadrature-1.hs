gaussLegendre n f a b = d*sum [ w x*f(m + d*x) | x <- roots ]
  where d = (b - a)/2
        m = (b + a)/2
        w x = 2/(1-x^2)/(legendreP' n x)^2
        roots = map (findRoot (legendreP n) (legendreP' n) . x0) [1..n]
        x0 i = cos (pi*(i-1/4)/(n+1/2))
