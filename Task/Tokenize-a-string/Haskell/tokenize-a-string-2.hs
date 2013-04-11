*Main> mapM_ putStrLn $ takeWhile (not.null) $ unfoldr (Just . second(drop 1). break (==',')) "Hello,How,Are,You,Today"
Hello
How
Are
You
Today
