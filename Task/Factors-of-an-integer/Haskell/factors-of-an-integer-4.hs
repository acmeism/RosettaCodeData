import Control.Arrow ((&&&))
import Data.Bool (bool)

integerFactors :: Int -> [Int]
integerFactors n =
  bool -- For perfect squares, `tail` excludes cofactor of square root
    (lows ++ (quot n <$> bool id tail (n == intSquared) (reverse lows)))
    []
    (n < 1)
  where
    (intSquared, lows) =
      (^ 2) &&& (filter ((0 ==) . rem n) . enumFromTo 1) $
      floor (sqrt $ fromIntegral n)

main :: IO ()
main = print $ integerFactors 600
