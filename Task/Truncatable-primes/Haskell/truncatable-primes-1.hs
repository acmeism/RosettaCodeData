import Data.Numbers.Primes(primes, isPrime)
import Data.List
import Control.Arrow

primes1e6 = reverse. filter (notElem '0'. show) $ takeWhile(<=1000000) primes

rightT, leftT :: Int -> Bool
rightT = all isPrime. takeWhile(>0). drop 1. iterate (`div`10)
leftT x = all isPrime. takeWhile(<x).map (x`mod`) $ iterate (*10) 10

main = do
  let (ltp, rtp) = (head. filter leftT &&& head. filter rightT) primes1e6
  putStrLn $ "Left truncatable  " ++ show ltp
  putStrLn $ "Right truncatable " ++ show rtp
