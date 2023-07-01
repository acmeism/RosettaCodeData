fizz :: (Integral a, Show a) => a -> [(a, String)] -> String
fizz a xs
    | null result = show a
    | otherwise   = result
    where result = concatMap (fizz' a) xs
          fizz' a (factor, str)
              | a `mod` factor == 0 = str
              | otherwise           = ""

main = do
    line <- getLine
    let n = read line
    contents <- getContents
    let multiples = map (convert . words) $ lines contents
    mapM_ (\ x -> putStrLn $ fizz x multiples) [1..n]
    where convert [x, y] = (read x, y)
