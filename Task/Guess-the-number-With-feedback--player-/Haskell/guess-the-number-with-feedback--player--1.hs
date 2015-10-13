main :: IO ()
main = do
    putStrLn "Please enter the range:"
    putStr   "From: "
    from <- getLine
    putStr   "To: "
    to   <- getLine
    case (from, to) of
         (_) | [(from', "")] <- reads from
             , [(to'  , "")] <- reads to
             , from'         < to' -> loop from' to'
         (_)  -> putStrLn "Invalid input." >> main

loop :: Integer -> Integer -> IO ()
loop from to = do
    let guess = (to + from) `div` 2
    putStrLn $ "Is it " ++ show guess ++ "? ((l)ower, (c)orrect, (h)igher)"
    answer <- getLine
    case answer of
        "c" -> putStrLn "Awesome!"
        "l" -> loop from  guess
        "h" -> loop guess to
        (_) -> putStrLn "Invalid answer." >> loop from to
