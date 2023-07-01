-- chart appears to be logarithmic scale on both axes
barChart :: Char -> [(Int, Time)] -> [String]
barChart ch lst = bar . scale <$> lst
  where
    scale (x,y) = (x, round $ (3*) $ log $ fromIntegral y)
    bar (x,y) = show x ++ "\t" ++ replicate y ' ' ++ [ch]

over :: String -> String -> String
over s1 s2 = take n $ zipWith f (pad s1) (pad s2)
  where
    f ' ' c = c
    f c ' ' = c
    f y _   = y
    pad = (++ repeat ' ')
    n = length s1 `max` length s2

comparison :: Ord a => [Sorter a] -> [Char] -> [a] -> IO ()
comparison sortings chars set = do
  results <- mapM (test set) sortings
  let charts = zipWith barChart chars results
  putStrLn $ replicate 50 '-'
  mapM_ putStrLn $ foldl1 (zipWith over) charts
  putStrLn $ replicate 50 '-'
  let times = map (fromInteger . snd) <$> results
  let ratios = mean . zipWith (flip (/)) (head times) <$> times
  putStrLn "Comparing average time ratios:"
  mapM_ putStrLn $ zipWith (\r s -> [s] ++ ": " ++ show r) ratios chars
  where
    mean lst = sum lst / genericLength lst

main = do
  putStrLn "comparing on list of ones"
  run ones
  putStrLn "\ncomparing on presorted list"
  run seqn
  putStrLn "\ncomparing on shuffled list"
  run rand
  where
    run = comparison [sort, isort, qsort, bsort] "siqb"
