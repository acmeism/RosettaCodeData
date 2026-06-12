ulams2 :: [Int]
ulams2 = 1 : 2 : nexts [2,1]
  where
    nexts us = u : nexts (u:us)
      where
        w = head us
        u = head $ head $ filter isSingleton $ group $ sort
            [v | s:ts <- tails us, t <- ts, let v = s + t, w < v]

    isSingleton [_] = True
    isSingleton _   = False
