composeList :: [a -> a] -> a -> a
composeList = flip (foldr id)


main :: IO ()
main = print $ composeList [(/ 2), succ, sqrt] 5
