factorize n = concat [divs n p | p <- [2..n], isPrime p]
  where
    divs n p = if rem n p==0 then p:divs (quot n p) p else []
