import Data.Numbers.Primes (isPrime)
import Data.List (intercalate)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

cubans :: [Int]
cubans = filter isPrime . map (\x -> (succ x ^ 3) - (x ^ 3)) $ [1 ..]

main :: IO ()
main = do
  mapM_ (\row -> mapM_ (printf "%10s" . thousands) row >> printf "\n") $ rows cubans
  printf "\nThe 100,000th cuban prime is: %10s\n" $ thousands $ cubans !! 99999
  where
    rows = chunksOf 10 . take 200
    thousands = reverse . intercalate "," . chunksOf 3 . reverse . show
