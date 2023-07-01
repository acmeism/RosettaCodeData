cartProdN :: [[a]] -> [[a]]
cartProdN = foldr
    (\xs as ->
        [ x : a
        | x <- xs
        , a <- as ])
    [[]]
