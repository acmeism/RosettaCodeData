main :: IO ()
main =
  mapM_
    print
    [ (x, y, z)
    | x <- [2, 4, 6]
    , y <- [1 .. 7]
    , z <- [12 - (x + y)]
    , y /= z && 1 <= z && z <= 7 ]
