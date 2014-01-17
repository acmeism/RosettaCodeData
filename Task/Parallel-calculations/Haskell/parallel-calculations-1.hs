mport Control.Parallel.Strategies
import Control.DeepSeq
import Data.List
import Data.Function

nums :: [Integer]
nums = [112272537195293
       ,112582718962171
       ,112272537095293
       ,115280098190773
       ,115797840077099
       ,1099726829285419]

lowestFactor :: Integral a => a -> a -> a
lowestFactor s n | n `rem` 2 == 0 = 2
                 | otherwise      = head $ y
  where y = [x | x <- [s..ceiling . sqrt $ fromIntegral n]
            ++ [n], n `rem` x == 0, x `rem` 2 /= 0]

primeFactors l n = f n l []
    where f n l xs = if n > 1 then f (n `div` l) (lowestFactor (max l 3)  (n `div` l)) (l:xs)
                              else xs

minPrimes ns = (\(x,y) -> (x,primeFactors y x)) $
              maximumBy (compare `on` snd) $
              zip ns (parMap rdeepseq (lowestFactor 3) ns)

main :: IO ()
main = do
    print $ minPrimes nums
