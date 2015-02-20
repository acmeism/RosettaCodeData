data Door = Open | Closed deriving Show

toggle Open   = Closed
toggle Closed = Open

toggleEvery :: [Door] -> Int -> [Door]
toggleEvery xs k = zipWith ($) fs xs
    where fs = cycle $ (replicate (k-1) id) ++ [toggle]

run n = foldl toggleEvery (replicate n Closed) [1..n]
