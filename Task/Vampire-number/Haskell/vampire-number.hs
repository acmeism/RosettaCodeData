import Data.List (sort)
import Control.Arrow ((&&&))

-- VAMPIRE NUMBERS ------------------------------------------------------------
vampires :: [Int]
vampires = filter ((0 <) . length . fangs) [1 ..]

fangs :: Int -> [(Int, Int)]
fangs n
  | odd w = []
  | otherwise = ((,) <*> quot n) <$> filter isfang (integerFactors n)
  where
    ndigit :: Int -> Int
    ndigit 0 = 0
    ndigit n = 1 + ndigit (quot n 10)
    w = ndigit n
    xmin = 10 ^ (quot w 2 - 1)
    xmax = xmin * 10
    isfang x =
      x > xmin &&
      x < y &&
      y < xmax && -- same length
      (quot x 10 /= 0 || quot y 10 /= 0) && -- not zero-ended
      sort (show n) == sort (show x ++ show y)
      where
        y = quot n x

-- FACTORS --------------------------------------------------------------------
integerFactors :: Int -> [Int]
integerFactors n
  | n < 1 = []
  | otherwise =
    lows ++
    (quot n <$>
     (if intSquared == n -- A perfect square,
        then tail -- and cofactor of square root would be redundant.
        else id)
       (reverse lows))
  where
    (intSquared, lows) =
      (^ 2) &&& (filter ((0 ==) . rem n) . enumFromTo 1) $
      floor (sqrt $ fromIntegral n)

-- TEST -----------------------------------------------------------------------
main :: IO [()]
main =
  mapM
    (print . ((,) <*>) fangs)
    (take 25 vampires ++ [16758243290880, 24959017348650, 14593825548650])
