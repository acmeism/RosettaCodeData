import Data.Numbers.Primes (primes)
import Text.Printf (printf)


merge :: Ord a => [a] -> [a] -> [a]
merge [] b = b
merge a@(x:xs) b@(y:ys) | x < y     = x : merge xs b
                        | otherwise = y : merge a ys

nSmooth :: Integer -> [Integer]
nSmooth p = 1 : foldr u [] factors
 where
   factors = takeWhile (<=p) primes
   u n s = r
    where r = merge s (map (n*) (1:r))

main :: IO ()
main = do
  mapM_ (printf "First 25 %d-smooth:\n%s\n\n" <*> showTwentyFive) firstTenPrimes
  mapM_
    (printf "The 3,000 to 3,202 %d-smooth numbers are:\n%s\n\n" <*> showRange1)
    firstTenPrimes
  mapM_
    (printf "The 30,000 to 30,019 %d-smooth numbers are:\n%s\n\n" <*> showRange2)
    [503, 509, 521]
  where
    firstTenPrimes = take 10 primes
    showTwentyFive = show . take 25 . nSmooth
    showRange1 = show . ((<$> [2999 .. 3001]) . (!!) . nSmooth)
    showRange2 = show . ((<$> [29999 .. 30018]) . (!!) . nSmooth)
