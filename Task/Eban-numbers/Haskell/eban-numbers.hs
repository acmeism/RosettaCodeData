{-# LANGUAGE NumericUnderscores #-}
import Data.List (intercalate)
import Text.Printf (printf)
import Data.List.Split (chunksOf)

isEban :: Int -> Bool
isEban n = all (`elem` [0, 2, 4, 6]) z
 where
  (b, r1) = n  `quotRem` (10 ^ 9)
  (m, r2) = r1 `quotRem` (10 ^ 6)
  (t, r3) = r2 `quotRem` (10 ^ 3)
  z       = b : map (\x -> if x >= 30 && x <= 66 then x `mod` 10 else x) [m, t, r3]

ebans = map f
 where
  f x = (thousands x, thousands $ length $ filter isEban [1..x])

thousands:: Int -> String
thousands = reverse . intercalate "," . chunksOf 3 . reverse . show

main :: IO ()
main = do
  uncurry (printf "eban numbers up to and including 1000: %2s\n%s\n\n") $ r [1..1000]
  uncurry (printf "eban numbers between 1000 and 4000: %2s\n%s\n\n") $ r [1000..4000]
  mapM_ (uncurry (printf "eban numbers up and including %13s: %5s\n")) ebanCounts
 where
  ebanCounts = ebans [        10_000
                     ,       100_000
                     ,     1_000_000
                     ,    10_000_000
                     ,   100_000_000
                     , 1_000_000_000 ]
  r = ((,) <$> thousands . length <*> show) . filter isEban
