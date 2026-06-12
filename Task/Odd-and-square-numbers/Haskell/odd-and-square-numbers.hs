main :: IO ()
main = print $ takeWhile (<1000) $ filter odd $ map (^2) $ [10..]
