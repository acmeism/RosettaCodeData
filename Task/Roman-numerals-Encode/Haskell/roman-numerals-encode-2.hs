import Data.Bifunctor (first)
import Data.List (mapAccumL)
import Data.Tuple (swap)

roman :: Int -> String
roman =
  romanFromInt $
  zip
    [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    (words "M CM D CD C XC L XL X IX V IV I")

romanFromInt :: [(Int, String)] -> Int -> String
romanFromInt nks n = concat . snd $ mapAccumL go n nks
  where
    go a (v, s) = swap $ first ((>> s) . enumFromTo 1) $ quotRem a v

main :: IO ()
main = (putStrLn . unlines) (roman <$> [1666, 1990, 2008, 2016, 2018])
