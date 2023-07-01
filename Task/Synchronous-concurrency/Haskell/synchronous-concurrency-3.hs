writer takeLine putCount = loop 0
  where loop n = do l <- takeLine
                    case l of
                       Just x  -> do putStrLn x
                                     loop (n+1)
                       Nothing -> putCount n
