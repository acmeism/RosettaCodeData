module Main where

import Control.Monad
import Data.List
import Data.Monoid
import Text.Printf

entropy :: (Ord a) => [a] -> Double
entropy = sum
        . map (\c -> (c *) . logBase 2 $ 1.0 / c)
        . (\cs -> let { sc = sum cs } in map (/ sc) cs)
        . map (fromIntegral . length)
        . group
        . sort

fibonacci :: (Monoid m) => m -> m -> [m]
fibonacci a b = unfoldr (\(a,b) -> Just (a, (b, a <> b))) (a,b)

main :: IO ()
main = do
    printf "%2s %10s %17s %s\n" "N" "length" "entropy" "word"
    zipWithM_ (\i v -> let { l = length v } in printf "%2d %10d %.15f %s\n"
                   i l (entropy v) (if l > 40 then "..." else v))
              [1..38::Int]
              (take 37 $ fibonacci "1" "0")
