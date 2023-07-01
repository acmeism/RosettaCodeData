idMatrix :: Int -> [[Int]]
idMatrix n =
  let xs = [1 .. n]
  in (\x -> fromEnum . (x ==) <$> xs) <$> xs

main :: IO ()
main = (putStr . unlines) $ unwords . fmap show <$> idMatrix 5
