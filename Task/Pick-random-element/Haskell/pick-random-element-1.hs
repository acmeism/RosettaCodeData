import Random (randomRIO)

pick :: [a] -> IO a
pick xs = randomRIO (0, length xs - 1) >>= return . (xs !!)

x <- pick [1 2 3]
