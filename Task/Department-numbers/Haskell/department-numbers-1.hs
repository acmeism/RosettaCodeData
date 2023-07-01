main :: IO ()
main =
  mapM_ print $
  [2, 4, 6] >>=
  \x ->
     [1 .. 7] >>=
     \y ->
        [12 - (x + y)] >>=
        \z ->
           case y /= z && 1 <= z && z <= 7 of
             True -> [(x, y, z)]
             _ -> []
