idMatrix :: Int -> [[Int]]
idMatrix n =
  let xs = [1 .. n]
  in xs >>= \x -> [xs >>= \y -> [fromEnum (x == y)]]

main :: IO ()
main = (putStr . unlines) $ fmap (unwords . fmap show) (idMatrix 5)
