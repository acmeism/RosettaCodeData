distL1 (x,y) (a,b) = max (abs $ x-a) (abs $ y-b)

main = let
  g = grid 9 9 `withHole` wall
  wall = [ (2,4),(2,5),(2,6),(3,6)
         , (4,6),(5,6),(5,5),(5,4)
         , (5,3),(5,2),(3,2),(4,2) ]
  path = shortestPath g distL1 (1,1) (7,7)
  picture = [ [ case (i,j) of
                  p | p `elem` path -> '*'
                    | p `elem` wall -> '#'
                    | otherwise     -> ' '
              | i <- [0..8] ]
            | j <- [0..8] ]
  in do
    print path
    mapM_ putStrLn picture
    putStrLn $ "Path score: " <> show (length path)
