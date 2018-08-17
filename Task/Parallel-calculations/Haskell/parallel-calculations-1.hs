import Control.Parallel.Strategies (parMap, rdeepseq)
import Control.DeepSeq (NFData)
import Data.List (maximumBy)
import Data.Function (on)

nums :: [Integer]
nums =
  [ 112272537195293
  , 112582718962171
  , 112272537095293
  , 115280098190773
  , 115797840077099
  , 1099726829285419
  ]

lowestFactor
  :: Integral a
  => a -> a -> a
lowestFactor s n
  | even n = 2
  | otherwise = head y
  where
    y =
      [ x
      | x <- [s .. ceiling . sqrt $ fromIntegral n] ++ [n]
      , n `rem` x == 0
      , odd x ]

primeFactors
  :: Integral a
  => a -> a -> [a]
primeFactors l n = f n l []
  where
    f n l xs =
      if n > 1
        then f (n `div` l) (lowestFactor (max l 3) (n `div` l)) (l : xs)
        else xs

minPrimes
  :: (Control.DeepSeq.NFData a, Integral a)
  => [a] -> (a, [a])
minPrimes ns =
  (\(x, y) -> (x, primeFactors y x)) $
  maximumBy (compare `on` snd) $ zip ns (parMap rdeepseq (lowestFactor 3) ns)

main :: IO ()
main = print $ minPrimes nums
