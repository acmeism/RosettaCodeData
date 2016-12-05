q = qq (listArray (1,2) [1,1]) 1 where
    qq ar n    = (arr!n) : qq arr (n+1) where
        l = snd (bounds ar)
        step n =arr!(n - (fromIntegral (arr!(n - 1)))) +
            arr!(n - (fromIntegral (arr!(n - 2))))
        arr :: Array Int Integer
        arr | n <= l = ar
            | otherwise = listArray (1, l*2)$
                ([ar!i | i <- [1..l]] ++
                 [step i | i <- [l+1..l*2]])

main = do
    putStr("first 10: "); print (take 10 q)
    putStr("1000-th:  "); print (q !! 999)
    putStr("flips: ")
    print $ length $ filter id $ take 100000 (zipWith (>) q (tail q))
