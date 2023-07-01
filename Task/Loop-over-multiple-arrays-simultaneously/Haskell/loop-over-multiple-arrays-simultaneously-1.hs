{-# LANGUAGE ParallelListComp #-}
main = sequence [ putStrLn [x, y, z] | x <- "abc" | y <- "ABC" | z <- "123"]
