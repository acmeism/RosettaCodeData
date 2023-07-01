squares = concat $ take 10 $ iterateM mkBranches start
  where start = [(0,100),(100,100),(100,0),(0,0)]
        iterateM f x = iterate (>>= f) (pure x)
