gate :: Eq a => [a] -> [a] -> [Door]
gate (x:xs) (y:ys) | x == y  =  Open   : gate xs ys
gate (x:xs) ys               =  Closed : gate xs ys
gate []     _                =  []

run n = gate [1..n] [k*k | k <- [1..]]
