import Data.List.Split (chunksOf)
import Math.NumberTheory.Primes (factorise)
import Text.Printf (printf)

-- True iff the argument is a square-free number.
isSquareFree :: Integer -> Bool
isSquareFree = all ((== 1) . snd) . factorise

-- All square-free numbers in the range [lo, hi].
squareFrees :: Integer -> Integer -> [Integer]
squareFrees lo hi = filter isSquareFree [lo..hi]

-- The result of `counts limits values' is the number of values less than or
-- equal to each successive limit.  Both limits and values are assumed to be
-- in increasing order.
counts :: (Ord a, Num b) => [a] -> [a] -> [b]
counts = go 0
  where go c lims@(l:ls) (v:vs) | v > l     = c : go (c+1) ls vs
                                | otherwise = go (c+1) lims vs
        go _ [] _  = []
        go c ls [] = replicate (length ls) c

printSquareFrees :: Int -> Integer -> Integer -> IO ()
printSquareFrees cols lo hi =
  let ns = squareFrees lo hi
      title = printf "Square free numbers from %d to %d\n" lo hi
      body = unlines $ map concat $ chunksOf cols $ map (printf " %3d") ns
  in putStrLn $ title ++ body

printSquareFreeCounts :: [Integer] -> Integer -> Integer -> IO ()
printSquareFreeCounts lims lo hi =
  let cs = counts lims $ squareFrees lo hi :: [Integer]
      title = printf "Counts of square-free numbers\n"
      body = unlines $ zipWith (printf "  from 1 to %d: %d") lims cs
  in putStrLn $ title ++ body

main :: IO ()
main = do
  printSquareFrees 20 1 145
  printSquareFrees 5 1000000000000 1000000000145
  printSquareFreeCounts [100, 1000, 10000, 100000, 1000000] 1 1000000
