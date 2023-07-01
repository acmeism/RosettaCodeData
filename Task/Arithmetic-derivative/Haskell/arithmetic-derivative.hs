import Control.Monad (forM_)
import Data.List (intercalate)
import Data.List.Split (chunksOf)
import Math.NumberTheory.Primes (factorise, unPrime)
import Text.Printf (printf)

-- The arithmetic derivative of a number, which is assumed to be non-negative.
arithderiv_ :: Integer -> Integer
arithderiv_ 0 = 0
arithderiv_ n = foldr step 0 $ factorise n
  where step (p, v) s = s + n `quot` unPrime p * fromIntegral v

-- The arithmetic derivative of any integer.
arithderiv :: Integer -> Integer
arithderiv n | n < 0     = negate $ arithderiv_ (negate n)
             | otherwise = arithderiv_ n

printTable :: [Integer] -> IO ()
printTable = putStrLn
           . intercalate "\n"
           . map unwords
           . chunksOf 10
           . map (printf "%5d")

main :: IO ()
main = do
  printTable [arithderiv n | n <- [-99..100]]
  putStrLn ""
  forM_ [1..20 :: Integer] $ \i ->
    let q = 7
        n = arithderiv (10^i) `quot` q
    in printf "D(10^%-2d) / %d = %d\n" i q n
