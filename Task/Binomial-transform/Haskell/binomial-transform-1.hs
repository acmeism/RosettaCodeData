module Main (main) where

import Control.Monad (forM_)
import Lib

main :: IO ()
main = forM_ seqs testSeq
    where
        testSeq (n, s) = do
            print $ n <> ": " <> show s
            print $ "   Forward: " <> show (forward s)
            print $ "   Inverse: " <> show (inverse s)
            print $ "   Self: " <> show (self s)
            print $ "   Inverse of Forward: " <> show (inverse (forward s))
            print $ "   Self of Self: " <> show (self (self s))


seqs :: [(String, [Integer])]
seqs =
    [
        ("Catalan", [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440]),
        ("Prime flip flop", [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0]),
        ("Fibonacci", [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377]),
        ("Padovan", [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9])
    ]
