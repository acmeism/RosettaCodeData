readProgram :: String -> [Ratio a]
readProgram = map (toFrac . splitOn "/") . splitOn ","
  where toFrac [n,d] = read n % read d
