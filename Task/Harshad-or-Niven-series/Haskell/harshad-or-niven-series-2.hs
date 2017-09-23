harshadSeries :: [Int]
harshadSeries = filter ((0 ==) . (rem <*> (sum . digitList))) [1 ..]

digitList :: Int -> [Int]
digitList 0 = []
digitList n = rem n 10 : digitList (quot n 10)

main :: IO ()
main = mapM_ print $ [take 20, take 1 . dropWhile (<= 1000)] <*> [harshadSeries]
