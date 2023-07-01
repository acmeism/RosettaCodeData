main :: IO ()
main =
  mapM_ print $
  do x <- [2, 4, 6]
     y <- [1 .. 7]
     z <- [12 - (x + y)]
     if y /= z && 1 <= z && z <= 7
       then [(x, y, z)]
       else []
