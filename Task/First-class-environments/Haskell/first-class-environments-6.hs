fixedPoint f x
  | fx == x = [x]
  | otherwise = x : fixedPoint f fx
  where fx = f x

prettyPrint field = putStrLn . foldMap (format.field)
  where format n = (if n < 10 then " " else "") ++ show n ++ " "

main = do
  let result = fixedPoint (map process) environments
  mapM_ (prettyPrint value) result
  putStrLn (replicate 36 '-')
  prettyPrint count (last result)
