multOrder a m
  | gcd a m /= 1  = error "Arguments not coprime"
  | otherwise     = foldl1' lcm $ map (multOrder' a) $ primeFacsExp m

multOrder' a (p,k) = r where
  pk = p^k
  t = (p-1)*p^(k-1) -- totient \Phi(p^k)
  r = product $ map find_qd $ primeFacsExp $ t
  find_qd (q,e) = q^d where
    x = powerMod pk a (t `div` (q^e))
    d = length $ takeWhile (/= 1) $ iterate (\y -> powerMod pk y q) x
