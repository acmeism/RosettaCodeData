import Control.Monad (liftM)
import Data.Bits (Bits, testBit, shiftR)
import System.Random (Random, getStdGen, randomRs)
import System.IO.Unsafe (unsafePerformIO)
import Prelude hiding (even, odd)

odd :: (Integral a, Bits a) => a -> Bool
odd = (`testBit` 0)

even :: (Integral a, Bits a) => a -> Bool
even = not . odd

-- modPow - Recursive modular exponentiation by taking successive powers of two
modPow :: (Integral a, Bits a) => a -> a -> a -> a
modPow _ 0 _ = 1
modPow base ex m = let term
                         | testBit ex 0 = base `mod` m
                         | otherwise    = 1
                   in (term * modPow (base^2 `mod` m) (ex `shiftR` 1) m) `mod` m

isPrime :: (Integral a, Bits a, Random a) => a -> a -> Bool
isPrime n k
    | n < 4     = if n > 1 then True else False -- Deal with 0-3.
    | even n    = False
    | otherwise = let randPool = unsafePerformIO $ randNums (n - 2)
                  in witness k randPool
    where
        randNums upper = do
            g <- getStdGen
            return (randomRs (2, upper) g)

        (d, r) = let decompose d r
                        | odd d     = (d, r)
                        | otherwise = decompose (d `shiftR` 1) (r + 1)
                 in decompose (n - 1) 0

        witness 0 _ = True
        witness k (a:rands)
            | x == 1 || x == n - 1 = witness (k - 1) rands
            | otherwise            = check x (r - 1)
            where
                x = modPow a d n

                check _ 0 = False
                check x count
                    | x' == 1     = False
                    | x' == n - 1 = witness (k - 1) rands
                    | otherwise   = check x' (count - 1)
                    where x' = modPow x 2 n

-- main function for testing
main :: IO()
main = do
    [n,k] <- liftM (map (\x -> read x :: Integer) . words) getLine
    print $ isPrime n k
