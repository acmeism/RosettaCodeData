import Data.List (sort)

task :: Integral a => [a] -> a
task = go . (0 :) . sort . filter (> 0)
  where
    go [x] = succ x
    go (w : xs@(x : _))
      | x == succ w = go xs
      | otherwise = succ w


main :: IO ()
main =
  print $
    map
      task
      [[1, 2, 0], [3, 4, -1, 1], [7, 8, 9, 11, 12]]
