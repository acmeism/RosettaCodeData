-- Three infinite lists, corresponding to the three definitions in the problem
-- statement.

cats1 :: [Integer]
cats1 = (\n -> product [n + 2 .. 2 * n] `div` product [1 .. n]) <$> [0 ..]

cats2 :: [Integer]
cats2 = 1 : fmap (\n -> sum $ zipWith (*) (reverse (take n cats2)) cats2) [1 ..]

cats3 :: [Integer]
cats3 = scanl (\c n -> c * 2 * (2 * n - 1) `div` (n + 1)) 1 [1 ..]

main :: IO ()
main = mapM_ (print . take 15) [cats1, cats2, cats3]
