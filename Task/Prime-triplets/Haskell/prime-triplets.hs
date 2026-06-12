primes = filterPrime [2..] where
  filterPrime (p:xs) =
    p : filterPrime [x | x <- xs, x `mod` p /= 0]


triplets :: Integer -> [(Integer, Integer, Integer)]
triplets k = let p = take (fromInteger k) primes in [(x,y,z) |
    x <- [2..k],
    let y = x+2,
    let z = x+6,
    x `elem` p,
    y `elem` p,
    z `elem` p
    ]
