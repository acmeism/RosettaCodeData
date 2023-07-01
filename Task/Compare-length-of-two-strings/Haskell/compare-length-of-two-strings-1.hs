task s1 s2 = do
  let strs = if length s1 > length s2 then [s1, s2] else [s2, s1]
  mapM_ (\s -> putStrLn $ show (length s) ++ "\t" ++ show s) strs
