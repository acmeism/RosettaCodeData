pytr n = filter (\(_, a, b, c) -> a+b+c <= n) [(prim a b c, a, b, c) | a <- [1..n], b <- [1..n], c <- [1..n], a < b && b < c, a^2 + b^2 == c^2]
    where prim a b _ = gcd a b == 1

main = putStrLn $ "Up to 100 there are " ++ (show $ length xs) ++ " triples, of which " ++ (show $ length $ filter (\(x,_,_,_) -> x == True) xs) ++ " are primitive."
    where xs = pytr 100
