count :: Eq a => [a] -> [a] -> Int
count []  = error "empty substring"
count sub = go
  where
    go = scan sub . dropWhile (/= head sub)
    scan _ [] = 0
    scan [] xs = 1 + go xs
    scan (x:xs) (y:ys) | x == y    = scan xs ys
                       | otherwise = go ys
