{-# LANGUAGE BangPatterns #-}
import Data.List
import Data.Numbers.Primes -- Hackage package primes-0.2.1.0

{- Computes the next row of the Seidel triangle given the next element of
   the input sequence and the current row of the Seidel triangle. -}
seidelStep :: Num a => a -> [a] -> [a]
seidelStep = go []
  where go acc !a []       = a : acc
        go acc !a (x : xs) = go (a : acc) (a + x) xs

{- Computes the Seidel triangle of the given input sequence -}
seidelTriangle :: Num a => [a] -> [[a]]
seidelTriangle = aux []
  where aux _  []       = []
        aux xs (a : as) = let ys = seidelStep a xs in reverse ys : aux ys as

{- Computes the Boustrophedon transform (rightmost column of the Seidel triangle -}
boustrophedon :: Num a => [a] -> [a]
boustrophedon = map last . seidelTriangle

{- The code from here on only takes care of printing the examples -}
printSequence :: Maybe String -> [Integer] -> IO ()
printSequence s as = mapM_ putStrLn [
     maybe "" (++ ": ") s ++ mk 5 as,
     " -> " ++ mk 15 bs,
     "1000th term: " ++ abbreviateNumber (bs !! 999), ""]
  where mk n xs = "(" ++ intercalate ", " (map show (take n xs)) ++ ", ...)"
        bs = boustrophedon as
        abbreviateNumber n = n'' ++ " (" ++ show l ++ " digits)"
          where (n', l) = (show n, length n')
                n'' = if l <= 40 then n'
                      else take 20 n' ++ "..." ++ reverse (take 20 (reverse n'))

main = do
  printSequence Nothing (1 : repeat 0)
  printSequence Nothing (repeat 1)
  printSequence (Just "(-1)^n") (cycle [1, -1])
  printSequence (Just "Primes") primes
  printSequence (Just "Fibonacci") (let fibs = 1 : 1 : zipWith (+) fibs (tail fibs) in fibs)
  printSequence (Just "n!") (let facts = 1 : zipWith (*) facts [1..] in facts)
