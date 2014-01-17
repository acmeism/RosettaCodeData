triangles :: Int -> [[Int]]
triangles max_peri | max_peri < 12 = []
           | otherwise = concat tiers where
    tiers = takeWhile (not.null) $ iterate tier [[3,4,5]]
    tier = concatMap (filter ((<=max_peri).sum).tmul)
    tmul t = map (map (sum . zipWith (*) t))
        [[[ 1,-2,2],[ 2,-1,2],[ 2,-2,3]],
         [[ 1, 2,2],[ 2, 1,2],[ 2, 2,3]],
         [[-1, 2,2],[-2, 1,2],[-2, 2,3]]]

triangle_count max_p = (length t, sum $ map ((max_p `div`).sum) t)
    where t = triangles max_p

main = mapM_ putStrLn $
    map (\n -> show n ++ " " ++ show (triangle_count n)) $ map (10^) [1..]
