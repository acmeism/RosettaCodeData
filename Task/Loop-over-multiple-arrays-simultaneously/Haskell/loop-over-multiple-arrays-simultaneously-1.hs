{-# LANGUAGE ParallelListComp #-}
main = sequence [ putStrLn [x, y, z] | x <- "abd" | y <- "ABC" | z <- "123"]
