import Data.List     (groupBy, intersperse, mapAccumL, sortBy)
import Data.Ord      (comparing)
import Data.Function (on)
import Control.Arrow ((&&&))

-- Strings derived from integers,
-- and split into [(initial string, final character)] tuples.

xs :: [(String, Char)]
xs = (init &&& last) . show <$> [
      12, 127, 28, 42, 39, 113, 42, 18, 44, 118, 44, 37, 113, 124, 37, 48,
      127, 36, 29, 31, 125, 139, 131, 115, 105, 132, 104, 123, 35, 113, 122,
      42, 117, 119, 58, 109, 23, 105, 63, 27, 44, 105, 99, 41, 128, 121, 116,
      125, 32, 61, 37, 127, 29, 113, 121, 58, 114, 126, 53, 114, 96, 25, 109,
      7, 31, 141, 46, 13, 27, 43, 117, 116, 27, 7, 68, 40, 31, 115, 124, 42,
      128, 52, 71, 118, 117, 38, 27, 106, 33, 117, 116, 111, 40, 119, 47, 105,
      57, 122, 109, 124, 115, 43, 120, 43, 27, 27, 18, 28, 48, 125, 107,
      114, 34, 133, 45, 120, 30, 127, 31, 116, 146
    ]

-- Re-reading the initial strings as Ints
-- (empty strings read as 0),
ns :: [(Int, Char)]
ns =
  (\x ->
      let s = fst x
      in ( if null s
             then 0
             else (read s :: Int)
         , snd x)) <$>
  xs

-- and sorting and grouping by these initial Ints,
-- interpreting them as data-collection bins.
bins :: [[(Int, Char)]]
bins =
  groupBy (on (==) fst) (sortBy (mappend (comparing fst) (comparing snd)) ns)

-- Forming bars by the ordered accumulation of final characters in each bin,
bars :: [(Int, String)]
bars = (fst . head &&& fmap snd) <$> bins

-- and obtaining a complete series, with empty bar strings
-- interpolated for any missing integers.
series :: [(Int, String)]
series =
  (concat . snd) $
  mapAccumL
    (\a x ->
        let n = fst x
        in if a == n
             then (a + 1, [x])
             else (n + 1, ((\i -> (i, "")) <$> [a .. (n - 1)]) ++ [x]))
    1
    bars

-- Assembling the series as a list of strings with right-justified indices,
justifyRight :: Int -> Char -> String -> String
justifyRight n c s = drop (length s) (replicate n c ++ s)

plotLines :: [String]
plotLines =
  foldr
    (\x a ->
        (justifyRight 2 ' ' (show (fst x)) ++ " |  " ++ intersperse ' ' (snd x)) :
        a)
    []
    series

-- and passing these over to IO as a single newline-delimited string.
main :: IO ()
main = putStrLn $ unlines plotLines
