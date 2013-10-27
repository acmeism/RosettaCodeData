import Control.Parallel.Strategies
import Control.DeepSeq
import Data.List
import Data.Function

nums = [112272537195293
       ,112582718962171
       ,112272537095293
       ,115280098190773
       ,115797840077099
       ,1099726829285419]

factors :: Integral a => a -> [a]
factors n | n `rem` 2 == 0 = [2] ++ factors (n `quot` 2)
          | otherwise      = y
  where y = [x | x <- [3,5..ceiling . sqrt $ fromIntegral n]
            ++ [n], n `rem` x == 0]

minPrimes :: [Integer] -> (Integer, [Integer])
minPrimes ns = (\(x, y) -> (x, y:factors ( x `quot` y))) $
              maximumBy (compare `on` snd)
              (zip ns (parMap rdeepseq (head . factors) ns))

main :: IO ()
main = do
        putStrLn . concat $ ["The number with the "
                            , "largest minimum prime factor was:\n"
                            , show x, "\nWith factors: "]
        mapM_ print y
  where (x, y) =  (minPrimes nums)
