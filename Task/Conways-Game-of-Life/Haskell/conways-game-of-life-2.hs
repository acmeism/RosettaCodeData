import Data.List (unfoldr)

grid :: [String] -> (Int, Int, Grid)
grid l = (width, height, a)
  where (width, height) = (length $ head l, length l)
        a = listArray ((1, 1), (height, width)) $ concatMap f l
        f = map g
        g '.' = False
        g _   = True

printGrid :: Int -> Grid -> IO ()
printGrid width = mapM_ f . split width . elems
  where f = putStrLn . map g
        g False = '.'
        g _     = '#'

split :: Int -> [a] -> [[a]]
split n = takeWhile (not . null) . unfoldr (Just . splitAt n)

blinker = grid
   [".#.",
    ".#.",
    ".#."]

glider = grid
   ["............",
    "............",
    "............",
    ".......###..",
    ".......#....",
    "........#...",
    "............"]

printLife :: Int -> (Int, Int, Grid) -> IO ()
printLife n (w, h, g) = mapM_ f $ take n $ iterate (life w h) g
  where f g = do
            putStrLn "------------------------------"
            printGrid w g

main = printLife 10 glider
