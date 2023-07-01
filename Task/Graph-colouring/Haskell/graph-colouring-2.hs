ex1 = "0-1 1-2 2-0 3"
ex2 = "1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7"
ex3 = "1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6"
ex4 = "1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7"

task method ex =
  let g = readGraph ex
      cs = sortOn fst $ method g
      color n = fromJust $ lookup n cs
      ns = nodes g
      mkLine n = printf "%d\t%d\t%s\n" n (color n) (show (color <$> adjacentNodes g n))
  in do
    print ex
    putStrLn $ "nodes:\t" ++ show ns
    putStrLn $ "colors:\t" ++ show (nub (snd <$> cs))
    putStrLn "node\tcolor\tadjacent colors"
    mapM_ mkLine ns
    putStrLn ""
