import Text.Printf (printf)

-- format a 2d array of integers neatly
show2d a = unlines [unwords [printf "%3d" (a ! (x,y) :: Integer) | x <- axis fst] | y <- axis snd]
  where (l, h) = bounds a
        axis f = [f l .. f h]

main = mapM_ (putStr . show2d . zigZag) [(3,3), (4,4), (10,2)]
