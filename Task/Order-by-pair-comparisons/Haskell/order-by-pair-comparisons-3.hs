test method = do
  mapM_ showHist $ hist res
  putStrLn $ "Median number of comparisons: " ++ show (median res)
  putStrLn $ "Mean number of comparisons: " ++ show (mean res)
  where
    res = getSum . fst . method cmp <$> permutations [1..7]
    cmp a b = (Sum 1, compare a b)
    median lst = sort lst !! (length lst `div` 2)
    mean lst = sum (fromIntegral <$> lst) / genericLength lst
    hist lst = (\x -> (head x, length x)) <$> group (sort lst)
    showHist (n, l) = putStrLn line
      where
        line = show n ++ "\t" ++ bar ++ " " ++ show perc ++ "%"
        bar = replicate (max perc 1) '*'
        perc = (100 * l) `div` product [1..7]
