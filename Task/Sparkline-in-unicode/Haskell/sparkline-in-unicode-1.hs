import Data.Char (chr)
import Data.List.Split (splitOneOf)

toSparkLine :: [Double] -> [Char]
toSparkLine xs = map cl xs
    where
        top = maximum xs
        bot = minimum xs
        range = top - bot
        cl x = chr $ 0x2581 + round ((x - bot) / range * 7)

makeSparkLine :: String -> (String, Stats)
makeSparkLine xs = (toSparkLine parsed, stats parsed)
    where parsed = map read $ filter (not . null) $ splitOneOf " ," xs

data Stats = Stats { minValue, maxValue, rangeOfValues :: Double,
    numberOfValues :: Int }

instance Show Stats where
    show (Stats mn mx r n) = "min: " ++ show mn ++ "; max: " ++ show mx ++
        "; range: " ++ show r ++ "; no. of values: " ++ show n

stats :: [Double] -> Stats
stats xs = Stats { minValue = mn, maxValue = mx,
    rangeOfValues = mx - mn, numberOfValues = length xs }
    where
        mn = minimum xs
        mx = maximum xs

drawSparkLineWithStats :: String -> IO ()
drawSparkLineWithStats xs = putStrLn sp >> print st
    where (sp, st) = makeSparkLine xs

main :: IO ()
main = mapM_ drawSparkLineWithStats
    ["1 2 3 4 5 6 7 8 7 6 5 4 3 2 1",
    "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5",
    "3 2 1 0 -1 -2 -3 -4 -3 -2 -1 0 1 2 3",
    "-1000 100 1000 500 200 -400 -700 621 -189 3"]
