{-# LANGUAGE BangPatterns #-}

import Control.Monad (when)
import Data.Bool (bool)

totient
  :: (Integral a)
  => a -> a
totient n
  | n == 0 = 1 -- by definition phi(0) = 1
  | n < 0 = totient (-n) -- phi(-n) is taken to be equal to phi(n)
  | otherwise = loop n n 2 --
  where
    loop !m !tot !i
      | i * i > m = bool tot (tot - (tot `div` m)) (1 < m)
      | m `mod` i == 0 = loop m_ tot_ i_
      | otherwise = loop m tot i_
      where
        i_
          | i == 2 = 3
          | otherwise = 2 + i
        m_ = nextM m
        tot_ = tot - (tot `div` i)
        nextM !x
          | x `mod` i == 0 = nextM $ x `div` i
          | otherwise = x

main :: IO ()
main = do
  putStrLn "n\tphi\tprime\n---------------------"
  let loop !i !count
        | i >= 10 ^ 6 = return ()
        | otherwise = do
          let i_ = succ i
              tot = totient i_
              isPrime = tot == pred i_
              count_
                | isPrime = succ count
                | otherwise = count
          when (25 >= i_) $
            putStrLn $ show i_ ++ "\t" ++ show tot ++ "\t" ++ show isPrime
          when
            (i_ `elem`
             25 :
             [ 10 ^ k
             | k <- [2 .. 6] ]) $
            putStrLn $ "Number of primes up to " ++ show i_ ++ " = " ++ show count_
          loop (i + 1) count_
  loop 0 0
