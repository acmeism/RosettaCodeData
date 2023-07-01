import Data.Bifunctor (first, second)

-- choose m out of n items, return tuple of chosen and the rest

choose :: [Int] -> Int -> Int -> [([Int], [Int])]
choose [] _ _ = [([], [])]
choose aa _ 0 = [([], aa)]
choose aa@(a : as) n m
  | n == m = [(aa, [])]
  | otherwise =
    (first (a :) <$> choose as (n - 1) (m - 1))
      <> (second (a :) <$> choose as (n - 1) m)

partitions :: [Int] -> [[[Int]]]
partitions x = combos [1 .. n] n x
  where
    n = sum x
    combos _ _ [] = [[]]
    combos s n (x : xs) =
      [ l : r
        | (l, rest) <- choose s n x,
          r <- combos rest (n - x) xs
      ]

main :: IO ()
main = mapM_ print $ partitions [5, 5, 5]
