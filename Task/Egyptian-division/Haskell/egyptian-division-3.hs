doublings = iterate ((+) >>= id)

powers = doublings 1

k n (u, v) (ans, acc)
  | v + ans <= n = (v + ans, u + acc)
  | otherwise = (ans, acc)

egy n = snd . foldr (k n) (0, 0) . zip powers . takeWhile (<= n) . doublings

main :: IO ()
main = print $ egy 580 34
