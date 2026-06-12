divisors :: Int -> [Int]
divisors n = [d | d <- [1..n] , mod n d == 0 ]

isMultiplicativelyPerfect :: Int -> Bool
isMultiplicativelyPerfect n = (product $ divisors n) == n ^ 2

solution :: [Int]
solution = filter isMultiplicativelyPerfect [1..500]
