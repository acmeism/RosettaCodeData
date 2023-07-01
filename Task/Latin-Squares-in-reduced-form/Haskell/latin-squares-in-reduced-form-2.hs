task1 = do
  putStrLn "Latin squares of order 4:"
  mapM_ printTable $ latinSquares [1..4]

task2 = do
  putStrLn "Sizes of latin squares sets for different orders:"
  forM_ [1..6] $ \n ->
    let size = length $ latinSquares [1..n]
        total = fact n * fact (n-1) * size
        fact i = product [1..i]
    in printf "Order %v: %v*%v!*%v!=%v\n" n size n (n-1) total
