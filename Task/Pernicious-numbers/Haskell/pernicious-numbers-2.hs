import Data.Numbers.Primes (isPrime)
import Data.List (unfoldr)
import Data.Tuple (swap)
import Data.Bool (bool)

isPernicious :: Int -> Bool
isPernicious = isPrime . popCount

popCount :: Int -> Int
popCount =
  sum . unfoldr ((flip bool Nothing . Just . swap . flip quotRem 2) <*> (0 ==))

main :: IO ()
main =
  mapM_
    print
    [ take 25 $ filter isPernicious [1 ..]
    , filter isPernicious [888888877 .. 888888888]
    ]
