gcdFProg = start
  where
    start = do
      putStrLn "Enter two integers, or zero to exit"
      n <- readLn
      if n == 0
        then
          putStrLn "Exiting"
        else do
          m <- readLn
          putStrLn $ "GCD: " ++ show (loop n m)
          start

loop n m
  | n == m = n
  | n < m  = loop n (m-n)
  | n > m  = loop (n-m) m
