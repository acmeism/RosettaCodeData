showSteps :: Int -> [Step] -> String
showSteps = foldl go . show
  where
    go r (Div d) = r ++ "/" ++ show d
    go r (Sub s) = "(" ++ r ++ "-" ++ show s ++ ")"


task steps =  mapM_ (put . go) [1..10]
  where
    go n = showSteps n <$> minSteps steps n
    put (n,s) = putStrLn $ show n ++ ":\t" ++ s

task2 steps range = mapM_ put longest
  where
    put (n,(l,s)) = putStrLn $ show l ++ ": " ++
                    showSteps n s
    longest =
      head $ groupBy ((==) `on` (fst.snd)) $
      sortOn (negate . fst . snd) $
      zip [1..] (minSteps steps <$> range)
