data Door = Open | Closed deriving Show

toggle Open   = Closed
toggle Closed = Open

toggleEvery :: Int -> [Door] -> [Door]
toggleEvery k = zipWith toggleK [1..]
  where
    toggleK n door | n `mod` k == 0 = toggle door
                   | otherwise      = door

run n = foldr toggleEvery (replicate n Closed) [1..n]
