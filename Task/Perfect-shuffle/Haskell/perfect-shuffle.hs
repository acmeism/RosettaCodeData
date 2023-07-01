shuffle :: [a] -> [a]
shuffle lst = let (a,b) = splitAt (length lst `div` 2) lst
              in foldMap (\(x,y) -> [x,y]) $ zip a b

findCycle :: Eq a => (a -> a) -> a -> [a]
findCycle f x = takeWhile (/= x) $ iterate f (f x)

main = mapM_ report [ 8, 24, 52, 100, 1020, 1024, 10000 ]
  where
    report n = putStrLn ("deck of " ++ show n ++ " cards: "
                         ++ show (countSuffles n) ++ " shuffles!")
    countSuffles n = 1 + length (findCycle shuffle [1..n])
