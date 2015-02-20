expand p = scanl (\z i -> z * (p-i+1) `div` i) 1 [1..p]


test p | p < 2     = False
       | otherwise = and [mod n p == 0 | n <- init . tail $ expand p]


printPoly [1] = "1"
printPoly p   = concat [ unwords [pow i, sgn (l-i), show (p!!(i-1))]
                       | i <- [l-1,l-2..1] ] where
    l = length p
    sgn i = if even i then "+" else "-"
    pow i = take i "x^" ++ if i > 1 then show i else ""


main = do
    putStrLn "-- p: (x-1)^p for small p"
    putStrLn $ unlines [show i ++ ": " ++ printPoly (expand i) | i <- [0..10]]
    putStrLn "-- Primes up to 100:"
    print (filter test [1..100])
