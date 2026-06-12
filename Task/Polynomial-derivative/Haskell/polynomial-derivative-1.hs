deriv = zipWith (*) [1..] . tail

main = mapM_ (putStrLn . line) ps
  where
    line p = "\np  = " ++ show p ++ "\np' = " ++ show (deriv p)
    ps = [[5],[4,-3],[-1,6,5],[-4,3,-2,1],[1,1,0,-1,-1]]
