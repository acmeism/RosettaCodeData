expseq :: [Rational] -> [Rational]
expseq ps = zipWith (\p q -> p*fromInteger q) ps (scanl (*) 1 [1..])
