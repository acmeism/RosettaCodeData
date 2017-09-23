jseq :: Int -> Int -> [Int]
jseq n k = f n [1 .. n]
  where
    f 0 _ = []
    f m s = x : f (m - 1) (right ++ left)
      where
        (left, x:right) = splitAt (mod (k - 1) m) s

-- the final survivor is ((k + ...((k + ((k + 0)`mod` 1)) `mod` 2) ... ) `mod` n)
jos :: Int -> Int -> Int
jos n k = 1 + foldl (mod . (k +)) 0 [2 .. n]

main :: IO ()
main = do
  print $ jseq 41 3
  print $ jos 10000 100
