main = mapM_ (\n -> putStrLn $ show n ++ "\t" ++ spellOrdinal n)
  [1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 8007006005004003]
