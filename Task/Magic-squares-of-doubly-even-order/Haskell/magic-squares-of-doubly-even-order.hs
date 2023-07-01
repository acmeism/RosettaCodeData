import Data.List (transpose, unfoldr, intercalate)
import Data.List.Split (chunksOf)
import Data.Bool (bool)
import Control.Monad (forM_)

magicSquare :: Int -> [[Int]]
magicSquare n
  | rem n 4 > 0 = []
  | otherwise =
    chunksOf n $ zipWith (flip (bool =<< (-) limit)) series [1 .. sqr]
  where
    sqr = n * n
    limit = sqr + 1
    series
      | isPowerOf 2 n = magicSeries $ floor (logBase 2 (fromIntegral sqr))
      | otherwise =
        concat . concat . concat . scale $ scale <$> chunksOf 4 (magicSeries 4)
      where
        scale = replicate $ quot n 4

magicSeries :: Int -> [Bool]
magicSeries = (iterate ((++) <*> fmap not) [True] !!)

isPowerOf :: Int -> Int -> Bool
isPowerOf k n = until ((0 /=) . flip rem k) (`quot` k) n == 1

-- TEST AND DISPLAY FUNCTIONS --------------------------------------------------
checked :: [[Int]] -> (Int, Bool)
checked square =
  let diagonals =
        fmap (flip (zipWith (!!)) [0 ..]) . ((:) <*> (return . reverse))
      h:t =
        sum <$>
        square ++ -- rows
        transpose square ++ -- cols
        diagonals square -- diagonals
  in (h, all (h ==) t)

table :: String -> [[String]] -> [String]
table delim rows =
  let justifyRight c n s = drop (length s) (replicate n c ++ s)
  in intercalate delim <$>
     transpose
       ((fmap =<< justifyRight ' ' . maximum . fmap length) <$> transpose rows)

main :: IO ()
main =
  forM_ [4, 8, 16] $
  \n -> do
    let test = magicSquare n
    putStrLn $ unlines (table " " (fmap show <$> test))
    print $ checked test
    putStrLn []
