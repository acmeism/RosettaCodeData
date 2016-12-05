import System.Random (randomRIO)

pick :: [a] -> IO a
pick xs = fmap (xs !!) $ randomRIO (0, length xs - 1)

x <- pick [1 2 3]
