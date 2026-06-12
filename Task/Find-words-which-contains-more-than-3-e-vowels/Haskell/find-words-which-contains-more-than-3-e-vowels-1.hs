import System.IO

main = withFile "unixdict.txt" ReadMode $ \h -> do
    words <- fmap lines $ hGetContents h
    putStrLn $ unlines $ filter valid words

valid w = not (any (`elem` "aiou") w) && length (filter (=='e') w) > 3
