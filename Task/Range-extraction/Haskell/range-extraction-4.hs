import Data.List (intercalate, groupBy, isPrefixOf)
import Data.List.Split (chop)
import Data.Bool (bool)

rangeFormat :: [Int] -> String
rangeFormat xs =
  intercalate "," $
  (head . ((bool <*> tail) <*> (> 1) . length)) <$>
  groupBy isPrefixOf (rangeString <$> chop succSpan (zip xs (tail xs)))

rangeString [] = ""
rangeString xxs@(x:xs)
  | null xs = show (snd x)
  | otherwise = intercalate "-" (show <$> [fst x, snd (last xs)])

succSpan [] = ([], [])
succSpan (xxs@(x:xs))
  | null ys = ([x], xs)
  | otherwise = (ys, zs)
  where
    (ys, zs) = span (uncurry ((==) . succ)) xxs

main :: IO ()
main =
  putStrLn $
  rangeFormat [ 0, 1, 2, 4, 6, 7, 8, 11, 12, 14,
      15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
      25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
      37, 38, 39 ]
