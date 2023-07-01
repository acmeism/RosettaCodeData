zipWithLazy :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWithLazy f ~(x : xs) ~(y : ys) =
  f x y : zipWithLazy f xs ys

fuscs :: [Integer]
fuscs = 0 : s
  where
    s = 1 : concat (zipWithLazy f s (tail s))
    f x y = [x, x + y]

widths :: [(Int, Integer)]
widths = map head $ scanl f (zip [0 ..] fuscs) [2 ..]
  where
    f fis w = dropWhile ((< w) . length . show . snd) fis

main :: IO ()
main = do
  putStrLn "First 61 terms:"
  print $ take 61 fuscs
  putStrLn "\n(Index, Value):"
  mapM_ print $ take 5 widths
