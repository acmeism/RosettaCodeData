derangements :: [Integer]
derangements = map numerator
    (expseq (invexp/(1:(-1):repeat 0)))

invexp :: [Rational]
invexp = zipWith (%) (cycle [1,-1]) factorials
  where
    factorials = scanl (*) 1 [1..]
