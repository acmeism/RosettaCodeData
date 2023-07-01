mulfac :: (Num a, Enum a) => a -> [a]
mulfac k = 1 : s
  where
    s = [1 .. k] <> zipWith (*) s [k + 1 ..]

-- For single n:

mulfac1 :: (Num a, Enum a) => a -> a -> a
mulfac1 k n = product [n, n - k .. 1]

main :: IO ()
main =
  mapM_
    (print . take 10 . tail . mulfac)
    [1 .. 5]
