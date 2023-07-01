cubans :: [Int]
cubans =
    [ x
    | n <- [1 ..]
    , let x = (succ n ^ 3) - (n ^ 3)
    , isPrime x ]
