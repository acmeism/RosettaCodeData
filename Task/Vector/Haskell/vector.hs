add (u,v) (x,y)      = (u+x,v+y)
minus (u,v) (x,y)    = (u-x,v-y)
multByScalar k (x,y) = (k*x,k*y)
divByScalar (x,y) k  = (x/k,y/k)

main = do
  let vecA = (3.0,8.0) -- cartersian coordinates
  let (r,theta) = (3,pi/12) :: (Double,Double)
  let vecB = (r*(cos theta),r*(sin theta)) -- from polar coordinates to cartesian coordinates
  putStrLn $ "vecA = " ++ (show vecA)
  putStrLn $ "vecB = " ++ (show vecB)
  putStrLn $ "vecA + vecB = " ++ (show.add vecA $ vecB)
  putStrLn $ "vecA - vecB = " ++ (show.minus vecA $ vecB)
  putStrLn $ "2 * vecB = " ++ (show.multByScalar 2 $ vecB)
  putStrLn $ "vecA / 3 = " ++ (show.divByScalar vecA $ 3)
