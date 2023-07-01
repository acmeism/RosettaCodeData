import Data.Numbers.Primes
import Data.List (intercalate)
import Data.List.Split (chunksOf)

series :: Integer -> Integer -> [(Integer, Integer)]
series = go
  where
    go i n
      | isPrime i = (n, i) : go (i + i) (succ n)
      | otherwise = go (succ i) n

showPair :: (Integer, Integer) -> String
showPair (i, n) = show i ++ " -> " ++ showInteger n

showInteger :: Integer -> String
showInteger = reverse . intercalate "," . chunksOf 3 . reverse . show

main :: IO ()
main = mapM_ (putStrLn . showPair) (take 42 $ series 42 1)
