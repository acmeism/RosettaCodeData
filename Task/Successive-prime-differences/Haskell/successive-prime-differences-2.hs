{-# LANGUAGE NumericUnderscores #-}
import Data.Numbers.Primes (primes)

-- Type alias dictionary. Key is the difference group and value is a successive prime group.
type Result = [(String, [Int])]

findPrimes :: [Int] -> [[Int]] -> Result
findPrimes []     _     = []
findPrimes primes diffs = loopDiffs diffs <> findPrimes (tail primes) diffs
 where
  loopDiffs ds = [(show d, successive)
                  | d <- ds,
                    let successive = take (length d + 1) primes,
                    subs successive == d]
  subs = map (uncurry (-)) . init . tail . (\xs -> zip (xs <> [0]) (0 : xs))

showGroup :: Result -> String -> IO ()
showGroup result diffs = do
  putStrLn $ "Differences of " ++ diffs ++ ": " ++ show (length groups)
  putStrLn
    $  "First: "
    ++ firstGroup groups
    ++ "\nLast:  "
    ++ lastGroup groups
    ++ "\n"
 where
  groups     = [b | (a, b) <- result, a == diffs]
  firstGroup = show . head
  lastGroup  = show . last

main :: IO ()
main = mapM_ (showGroup result . show) diffs
 where
  (diffs, result) = groups [[2], [1], [2, 2], [2, 4], [4, 2], [6, 4, 2]]
  groups diffs = (diffs, findPrimes (takeWhile (< 1_000_000) primes) diffs)
