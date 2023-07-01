import Data.List
import Control.Monad (guard)

isPrime :: Int -> Bool
isPrime n
  | n <= 3 = n > 1
  | n `mod` 2 == 0 || n `mod` 3 == 0 = False
  | otherwise = l2 5 n
  where l2 d n = x > n || l3 d n
          where x = d * d
                l3 d n
                  | n `mod` d == 0       = False
                  | n `mod` (d + 2) == 0 = False
                  | otherwise = l2 (d + 6) n

showPrime :: Int -> Int -> [(Int, Int)]
showPrime i n = if isPrime i
                then (n, i) : showPrime (i+i) (n+1)
                else showPrime (i+1) n

digitGroup :: Int -> String
digitGroup = intercalate "," . reverse . map show . unfoldr (\n -> guard (n /= 0) >> pure (n `mod` 1000, n `div` 1000))

display :: (Int, Int) -> String
display (i, p) = show i ++ " " ++ digitGroup p

main = mapM_ (putStrLn . display) $ take 42 $ showPrime 42 1
