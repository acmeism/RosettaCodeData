integerRoot :: Integer -> Integer -> Integer
integerRoot n x =
  go $ iterate ((`div` n) . ((+) . (pn *) <*> (x `div`) . (^ pn))) 1
  where
    pn = pred n
    go (x:xs@(y:z:_))
      | x == y || x == z = min y z
      | otherwise = go xs

main :: IO ()
main = mapM_ (print . uncurry integerRoot) [(3, 8), (3, 9), (2, 2 * 100 ^ 2000)]
