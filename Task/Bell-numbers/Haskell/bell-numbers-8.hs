exp1 :: [Rational]
exp1 = 0 : map (1%) factorials
  where
    factorials = scanl (*) 1 [2..]

exps :: [Rational]
exps = 1 : zipWith (*) exps [ 1%n | n <- [1..] ]

bell :: [Integer]
bell = map numerator
    (expseq (exps |> exp1))
