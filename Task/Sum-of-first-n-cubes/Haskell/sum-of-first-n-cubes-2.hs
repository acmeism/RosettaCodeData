import Data.List (intercalate, scanl, transpose)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

------------------- SUM OF FIRST N CUBES -----------------

sumsOfFirstNCubes :: Int -> [Int]
sumsOfFirstNCubes n =
  scanl
    (\a -> (a +) . (^ 3))
    0
    [1 .. pred n]

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . table " " . chunksOf 5) $
    show <$> sumsOfFirstNCubes 50

------------------------- DISPLAY ------------------------

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
