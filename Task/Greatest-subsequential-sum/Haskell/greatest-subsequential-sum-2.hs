maxSubseq :: [Int] -> (Int, [Int])
maxSubseq =
  let go x ((h1, h2), sofar) =
        ((,) <*> max sofar) (max (0, []) (h1 + x, x : h2))
  in snd . foldr go ((0, []), (0, []))

main :: IO ()
main = print $ maxSubseq [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
