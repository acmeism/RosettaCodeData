{-# LANGUAGE NumericUnderscores #-}
import Data.Numbers.Primes (primes)

type Result = [(String, [Int])]

oneMillionPrimes :: Integral p => [p]
oneMillionPrimes = takeWhile (<1_000_000) primes

getGroups :: [Int] -> Result
getGroups [] = []
getGroups ps@(n:x:y:z:xs)
  | x-n == 6 && y-x == 4 && z-y == 2 = ("(6 4 2)", [n, x, y, z])            : getGroups (tail ps)
  | x-n == 4 && y-x == 2             = ("(4 2)", [n, x, y])                 : getGroups (tail ps)
  | x-n == 2 && y-x == 4             = ("(2 4)", [n, x, y]) : ("2", [n, x]) : getGroups (tail ps)
  | x-n == 2 && y-x == 2             = ("(2 2)", [n, x, y]) : ("2", [n, x]) : getGroups (tail ps)
  | x-n == 2                         = ("2", [n, x])                        : getGroups (tail ps)
  | x-n == 1                         = ("1", [n, x])                        : getGroups (tail ps)
  | otherwise                        = getGroups (tail ps)
getGroups (x:xs) = getGroups xs

groups :: Result
groups = getGroups oneMillionPrimes

showGroup :: String -> IO ()
showGroup group = do
  putStrLn $ "Differences of " ++ group ++ ": " ++ show (length r)
  putStrLn $ "First: " ++ show (head r) ++ "\nLast:  " ++ show (last r) ++ "\n"
  where r = foldr (\(a, b) c -> if a == group then b : c else c) [] groups

main :: IO ()
main = showGroup "2" >> showGroup "1" >> showGroup "(2 2)" >> showGroup "(2 4)" >> showGroup "(4 2)"
  >> showGroup "(6 4 2)"
