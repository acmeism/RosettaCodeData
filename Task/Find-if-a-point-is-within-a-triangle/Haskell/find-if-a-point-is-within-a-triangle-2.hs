tests = let
  t1 = Triangle (2,0) (-1,2) (-2,-2)
  bs = [(2,0), (-1,2), (-2,-2), (0,-1), (1/2,1), (-3/2,0)]
  is = [(0,0), (0,1), (-1,0), (-1,1), (-1,-1)]
  os = [(1,1), (-2,2), (100,100), (2.00000001, 0)]

  t2 = Triangle (1,2) (1,2) (-1,3)
  ps = [(1,2), (0,5/2), (0,2), (1,3)]

  in mapM_ print [ overlapping t1 <$> bs
                 , overlapping t1 <$> is
                 , overlapping t1 <$> os
                 , overlapping t2 <$> ps]
test2 = unlines
  [ [case overlapping t (i,j) of
        Inside -> '∗'
        Boundary -> '+'
        Outside -> '·'
    | i <- [-10..10] :: [Int] ]
  | j <- [-5..5] :: [Int] ]
  where t = Triangle (-8,-3) (8,1) (-1,4)
