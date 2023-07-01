import Data.Numbers.Primes (primeFactors)
import Data.List (unfoldr)
import Data.Tuple (swap)
import Data.Bool (bool)

isSmith :: Int -> Bool
isSmith n = pfs /= [n] && sumDigits n == foldr ((+) . sumDigits) 0 pfs
  where
    sumDigits = sum . baseDigits 10
    pfs = primeFactors n

baseDigits :: Int -> Int -> [Int]
baseDigits base = unfoldr remQuot
  where
    remQuot 0 = Nothing
    remQuot x = Just (swap (quotRem x base))

lowSmiths :: [Int]
lowSmiths = filter isSmith [2 .. 9999]

lowSmithCount :: Int
lowSmithCount = length lowSmiths

main :: IO ()
main =
  mapM_
    putStrLn
    [ "Count of Smith Numbers below 10k:"
    , show lowSmithCount
    , "\nFirst 15 Smith Numbers:"
    , unwords (show <$> take 15 lowSmiths)
    , "\nLast 12 Smith Numbers below 10k:"
    , unwords (show <$> drop (lowSmithCount - 12) lowSmiths)
    ]
