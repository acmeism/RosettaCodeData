shufflingQuality l1 l2 = length $ filter id $ zipWith (==) l1 l2

printTest prog = mapM_ test texts
  where
    test s = do
      x <- prog s
      putStrLn $ unwords $ [ show s
                           , show x
                           , show $ shufflingQuality s x]
    texts = [ "abba", "abracadabra", "seesaw", "elk" , "grrrrrr"
            , "up", "a", "aaaaa.....bbbbb"
            , "Rosetta Code is a programming chrestomathy site." ]
