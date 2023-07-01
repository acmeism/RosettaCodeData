import Control.Monad.Memo (Memo, memo, startEvalMemo)
import Math.NumberTheory.Primes.Testing (isPrime)
import System.Environment (getArgs)
import Text.Printf (printf)

type I = Integer

-- The n'th Motzkin number, where n is assumed to be ≥ 0.  We memoize the
-- computations using MonadMemo.
motzkin :: I -> Memo I I I
motzkin 0 = return 1
motzkin 1 = return 1
motzkin n = do
  m1 <- memo motzkin (n-1)
  m2 <- memo motzkin (n-2)
  return $ ((2*n+1)*m1 + (3*n-3)*m2) `div` (n+2)

-- The first n+1 Motzkin numbers, starting at 0.
motzkins :: I -> [I]
motzkins = startEvalMemo . mapM motzkin . enumFromTo 0

-- For i = 0 to n print i, the i'th Motzkin number, and if it's a prime number.
printMotzkins :: I -> IO ()
printMotzkins n = mapM_ prnt $ zip [0 :: I ..] (motzkins n)
  where prnt (i, m) = printf "%2d %20d %s\n" i m $ prime m
        prime m = if isPrime m then "prime" else ""

main :: IO ()
main = do
  [n] <- map read <$> getArgs
  printMotzkins n
