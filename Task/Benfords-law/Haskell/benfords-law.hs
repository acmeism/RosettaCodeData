import qualified Data.Map as M
import Data.Char (digitToInt)

fstdigit :: Integer -> Int
fstdigit = digitToInt . head . show

n = 1000 :: Int

fibs = 1 : 1 : zipWith (+) fibs (tail fibs)

fibdata = map fstdigit $ take n fibs

freqs = M.fromListWith (+) $ zip fibdata (repeat 1)

tab :: [(Int, Double, Double)]
tab =
  [ ( d
    , fromIntegral (M.findWithDefault 0 d freqs) / fromIntegral n
    , logBase 10.0 $ 1 + 1 / fromIntegral d)
  | d <- [1 .. 9] ]

main = print tab
