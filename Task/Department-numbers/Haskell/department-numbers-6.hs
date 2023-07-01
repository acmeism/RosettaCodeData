options :: Int -> Int -> Int -> [(Int, Int, Int)]
options lo hi total =
  let ds = [lo .. hi]
  in [ (x, y, z)
     | x <- filter even ds
     , y <- filter (/= x) ds
     , let z = total - (x + y)
     , y /= z && lo <= z && z <= hi ]
