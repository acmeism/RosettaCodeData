import Data.List (intercalate)

to :: Int -> Int -> [Int]
to _ 0 = []
to base i = to base q <> [r]
  where
    (q, r) = quotRem i base

from :: Int -> [Int] -> Int
from base = foldl1 ((+) . (base *))


--------------------------- TEST ---------------------------
main :: IO ()
main =
  mapM_
    (putStrLn .
     intercalate " <-> " .
     (((:) . (=<<) show . toBase) <*> (return . show . fromBase . toBase)))
    [2097152, 2097151]
  where
    b = 8
    fromBase = from b
    toBase = to b
